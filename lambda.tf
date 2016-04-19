resource "aws_lambda_function" "configruleslambda" {
    count = "${var.numcustomrules}"
    filename = "${lookup(var.customrules, count.index)}"
    function_name = "${replace(lookup(var.customrules, count.index),"/\\.\\w*$/","")}"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    handler = "exports.test"
    source_code_hash = "${base64sha256(file("${lookup(var.customrules, count.index)}"))}"
}

resource "aws_lambda_permission" "allow_aws_config" {
    count = "${var.numcustomrules}"
    statement_id = "AllowExecutionFromAWSConfig"
    action = "lambda:InvokeFunction"
    function_name = "${replace(lookup(var.customrules, count.index),"/\\.\\w*$/","")}"
    principal = "config.amazonaws.com"
}
