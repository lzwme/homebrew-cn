class C7n < Formula
  include Language::Python::Virtualenv

  desc "Rules engine for cloud security, cost optimization, and governance"
  homepage "https://github.com/cloud-custodian/cloud-custodian"
  url "https://ghproxy.com/https://github.com/cloud-custodian/cloud-custodian/archive/0.9.31.0.tar.gz"
  sha256 "73343e629fed1c95c521d3ce416219d8c70c3e5679a4ca0a75d879ba222a58cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "afe39142c7c9a6ba66b0b0a864b0ec48b59c8db5a9838ba18533650c6403c301"
    sha256 cellar: :any,                 arm64_ventura:  "d1d845bf7a85341830315115f4c796b8148054bd5d339d930ae7882ae65fa8cf"
    sha256 cellar: :any,                 arm64_monterey: "184b1814d4ada071dad931b572e8d3d05d307f46cdd9f1b9fe3b56abeea81372"
    sha256 cellar: :any,                 arm64_big_sur:  "044601b908d46d0029fa664c4f817884f41a03d4600e584bb77166f9779f6267"
    sha256 cellar: :any,                 sonoma:         "b9066c6e115ed4ba7c74bdae7b11b8ef4631a1e8acbb4af3e4d14f78a056aeb1"
    sha256 cellar: :any,                 ventura:        "425e3b811908786ab3c8ba3b498a3a903dc7e7169cf0dfc14277c92b1d5ec92b"
    sha256 cellar: :any,                 monterey:       "15d703b4b0f0bd0ff5fb01716be46a576ad8b88be50ee86052a33372c6249e1a"
    sha256 cellar: :any,                 big_sur:        "361d51976c28e3d1ffb7fb3c0c761f543e73e6cdfdd5ba174ee798a24b33dc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25957856506db6fad4a65766e25cc87b0c0828c635a173580881e2cd3ddfb1c8"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f7/d9/eafe5695c2db98f686b962a6985a8f41843da1dd2f5710311804eb885aea/boto3-1.28.25.tar.gz"
    sha256 "20feedb753e87d6dd55665e2e9dda08b031518291350c9c57b552c86a537fd4e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/bf/9c/4b5d7f9197510a898215becf62fd9862be3fb0a2a63af5b656d24daf9de0/botocore-1.31.25.tar.gz"
    sha256 "b8a40b0ca1e3c8290a4c0d473c8e1575d2e8b2ddc3c61dd8814c3976357cac84"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a6/1d/7a01bc53a248ddb14eb0dca86f089ddf848d7b9485c31d7f840f27acbcfe/importlib_metadata-5.2.0.tar.gz"
    sha256 "404d48d62bba0b7a77ff9d405efd91501bef2e67ff4ace0bed40a0cf28c3c7cd"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/99/ba/e51d376c6160d27669c7a9ad0b61d9cbd58fa58be6e6ddc0e7e0b6e6aa40/jsonschema-4.19.0.tar.gz"
    sha256 "6e1e7569ac13be8139b2dd2c21a55d350066ee3f80df06c608b398cdc6f30e8f"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/da/3c/fa2701bfc5d67f4a23f1f0f4347284c51801e9dbc24f916231c2446647df/rpds_py-0.9.2.tar.gz"
    sha256 "8d70e8f14900f2657c249ea4def963bed86a29b81f81f5b76b5a9215680de945"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # trim last decimal point version to match semver returned from version command
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/custodian version")

    (testpath/"good-policy.yml").write <<~EOF
      policies:
      - name: ec2-auto-tag-user
        resource: ec2
        mode:
          type: cloudtrail
          role: arn:aws:iam::{account_id}:role/custodian-auto-tagger
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
    output = shell_output("#{bin}/custodian validate --verbose #{testpath}/good-policy.yml 2>&1")
    assert_match "valid", output
    # has invalid "action" key instead of "actions"
    (testpath/"bad-policy.yml").write <<~EOF
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
    output = shell_output("#{bin}/custodian validate --verbose #{testpath}/bad-policy.yml 2>&1", 1)
    assert_match "invalid", output
  end
end