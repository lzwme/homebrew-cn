class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/a6/12/92bbf5db0eac6d901ccca51f001b64a4a57f8b06d7189147cd3c9ee570ce/parliament-1.6.4.tar.gz"
  sha256 "ea6b930de2afd2f1591d5624b56b8c9361e746c76ce50a9586cab209054dfa4c"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f4d966374db9c1111ef25434a0e215cba274343ac6fe34f63934a0be8f84d951"
    sha256 cellar: :any, arm64_tahoe:       "d0295fae2d2398f2102292b480553a5196ef11e7f8ee3b662b186208c3fd719d"
    sha256 cellar: :any, arm64_sequoia:     "9fbbfca6f3168ff23e757c5fee77c079e8b450dc71b07f0211312ac05f99ab20"
    sha256 cellar: :any, arm64_linux:       "01ec1557ca0970c44d916955326d55d1c9bb06ca6b1a2d059b5cf783b2ae8534"
    sha256 cellar: :any, x86_64_linux:      "c1af5015acea01a4061cc5042df3f1e8cf6b581da1e61cfa27e29f0397b32d9b"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/49/01/97aaee4d3e94467983a0c1b986ed4f4da48960d7ebc948e7d739c818cb59/boto3-1.43.106.tar.gz"
    sha256 "c11ad4c429a983493ba10014c7af9831a455c2c0eea91c1cefff74530e480277"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/11/b9/10ca68d0092895d5ea60f485a61a9840d5aff9d732c66ed60da53a20b1d4/botocore-1.43.106.tar.gz"
    sha256 "006870b3b4e40547232ad12c3bb4faec91bbbe0659aafaa3b7fa48a112c4ee97"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "json-cfg" do
    url "https://files.pythonhosted.org/packages/70/d8/34e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759/json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https://files.pythonhosted.org/packages/ee/da/a7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308/kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  # Replace `pkg_resources` for Python 3.12+: https://github.com/duo-labs/parliament/pull/258
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}/parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end

__END__
diff --git a/parliament/__init__.py b/parliament/__init__.py
index ea32a6f..6254b71 100644
--- a/parliament/__init__.py
+++ b/parliament/__init__.py
@@ -10,16 +10,18 @@ import json
 import jsoncfg
 import re
 
-import pkg_resources
+from importlib.resources import files, as_file
 import yaml
 
 # On initialization, load the IAM data
-iam_definition_path = pkg_resources.resource_filename(__name__, "iam_definition.json")
-iam_definition = json.load(open(iam_definition_path, "r"))
+iam_definition_path = files(__name__) / "iam_definition.json"
+with as_file(iam_definition_path) as path:
+    iam_definition = json.loads(path.read_text())
 
 # And the config data
-config_path = pkg_resources.resource_filename(__name__, "config.yaml")
-config = yaml.safe_load(open(config_path, "r"))
+config_path = files(__name__) / "config.yaml"
+with as_file(config_path) as path:
+    config = yaml.safe_load(path.read_text())
 
 
 def override_config(override_config_path):