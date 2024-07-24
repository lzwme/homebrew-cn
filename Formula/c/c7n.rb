class C7n < Formula
  include Language::Python::Virtualenv

  desc "Rules engine for cloud security, cost optimization, and governance"
  homepage "https:github.comcloud-custodiancloud-custodian"
  url "https:github.comcloud-custodiancloud-custodianarchiverefstags0.9.39.0.tar.gz"
  sha256 "d57f60eb1a607e4ac1fe4d3ba61e121e4d1ebce882cc0996a8aee1535b593a75"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8664ee1aa3caf94355c942c34a9ec117ef9361f43eb330def6b64981dd6fc038"
    sha256 cellar: :any,                 arm64_ventura:  "304c315bc68fd01a094a24a4194786053970329b865a26971ac8b036cb5fffda"
    sha256 cellar: :any,                 arm64_monterey: "de4baa01055c69f7a6808823d030d289ec2f33240d855f2b69a2902d734fac72"
    sha256 cellar: :any,                 sonoma:         "8ee7aa53b7cbb8ec43c85096ee7c0e2293a4c354d80ef35b448d3f4dbbcd7df0"
    sha256 cellar: :any,                 ventura:        "676c34b6cc5c4ef307e7623a7817a026f1d6f144c90d81f8e8b1b53e2610a39b"
    sha256 cellar: :any,                 monterey:       "1677b39b5383d9f119f367a69ec2ab320e3db14602578f0b51059c6306c867a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02aa319544710726246dc30bbd3af28b8fd5944244df7eec2e676ba90d611ac6"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackagesdbca45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91fargcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages2fae9a58247bdde0d4c7824c44756c075892642f824ce2077ddad69b0b4ac707boto3-1.34.146.tar.gz"
    sha256 "5686fe2a6d1aa1de8a88e9589cdcc33361640d3d7a13da718a30717248886124"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages20c46a63460a2904295f19d238491434c77a8e1b5ace1c846872709cfec5e54abotocore-1.34.146.tar.gz"
    sha256 "849cb8e54e042443aeabcd7822b5f2b76cb5cfe33fe3a71f91c7c069748a869c"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesd6b2c1d251caf629375d0dcced2c4fe6a7e2c38395c1f8438fd63e6cebfdb7caimportlib_metadata-8.1.0.tar.gz"
    sha256 "fcdcb1d5ead7bdf3dd32657bb94ebe9d2aabfe89a19782ddc32da5041d6ebfb4"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages36a283c3e2024cefb9a83d832e8835f9db0737a7a2b04ddfdd241c650b703db0rpds_py-0.19.0.tar.gz"
    sha256 "4fdc9afadbeb393b4bbbad75481e0ea78e4469f2e1d713a90811700830b553a9"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackagesd320b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # trim last decimal point version to match semver returned from version command
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}custodian version")

    (testpath"good-policy.yml").write <<~EOF
      policies:
      - name: ec2-auto-tag-user
        resource: ec2
        mode:
          type: cloudtrail
          role: arn:aws:iam::{account_id}:rolecustodian-auto-tagger
          # note {account_id} is optional. If you put that there instead of
          # your actual account number, when the policy is provisioned it
          # will automatically inherit the account_id properly
          events:
            - RunInstances
        filters:
          - tag:CreatorName: absent
        actions:
          - type: auto-tag-user
            tag: CreatorName
            principal_id_tag: CreatorId
    EOF
    output = shell_output("#{bin}custodian validate --verbose #{testpath}good-policy.yml 2>&1")
    assert_match "valid", output
    # has invalid "action" key instead of "actions"
    (testpath"bad-policy.yml").write <<~EOF
      policies:
      - name: ec2-auto-tag-user
        resource: ec2
        filters:
          - tag:CreatorName: absent
        action:
          - type: auto-tag-user
            tag: CreatorName
            principal_id_tag: CreatorId
    EOF
    output = shell_output("#{bin}custodian validate --verbose #{testpath}bad-policy.yml 2>&1", 1)
    assert_match "invalid", output
  end
end