class C7n < Formula
  include Language::Python::Virtualenv

  desc "Rules engine for cloud security, cost optimization, and governance"
  homepage "https:github.comcloud-custodiancloud-custodian"
  url "https:github.comcloud-custodiancloud-custodianarchiverefstags0.9.33.0.tar.gz"
  sha256 "6dd600c0202a4c29a9dd0edfb2c6afab1cad02c3c4d4af11a203e18354c6881d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8808b5c8536b2fda7cd8f4520e50fee88927727ea4cbfbd6b12079b0d925291c"
    sha256 cellar: :any,                 arm64_ventura:  "21ccdab6a819cebedd54a2e993123410a8d099e276ada9286c67e4c3326085a8"
    sha256 cellar: :any,                 arm64_monterey: "9a7910a299c715081875de12e5ba9c6e1cb31bb0496086accb3be32a96adfacb"
    sha256 cellar: :any,                 sonoma:         "c0102a678da97052849fb7ff4950e5be2655c2023a529785ddf27e53766ccf96"
    sha256 cellar: :any,                 ventura:        "d507b2e710448194853c167dc7f9dab081777ba14a50eb0a7c41803bbb07d783"
    sha256 cellar: :any,                 monterey:       "427330c38be586c59f7813e1b10a1e5b514ac945ff99baec815e8ff990ae13ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7504dd1ea51197b6e03210f6a25597dc7cca42bc9d1b705044ef2789614f54ec"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python-argcomplete"
  depends_on "python-setuptools"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages9d4d09a3eb00e6d017dafae80c6ea307992263405aad315587e0b63864ae97e5boto3-1.33.2.tar.gz"
    sha256 "70626598dd6698d6da8f2854a1ae5010f175572e2a465b2aa86685c745c1013c"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesd57340c9dd27acb7fad5d13259c406d305e4452f927d1b1dd16eee79586f5f9cbotocore-1.33.2.tar.gz"
    sha256 "16a30faac6e6f17961c009defb74ab1a3508b8abc58fab98e7cf96af0d91ea84"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages57b1b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesa61d7a01bc53a248ddb14eb0dca86f089ddf848d7b9485c31d7f840f27acbcfeimportlib_metadata-5.2.0.tar.gz"
    sha256 "404d48d62bba0b7a77ff9d405efd91501bef2e67ff4ace0bed40a0cf28c3c7cd"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackagesa87477bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03affjsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesd4848f5072792a260016048d3a5ae5186ec3be9e090480ddf5446484394dd8c3jsonschema_specifications-2023.11.1.tar.gz"
    sha256 "c9b234904ffe02f079bf91b14d79987faa685fd4b39c377a0996954c0090b9ca"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages80cee99def6196f53af8de12a9c36968de32f80b7871084d677d0dfcd2762d0breferencing-0.31.1.tar.gz"
    sha256 "81a1471c68c9d5e3831c30ad1dd9815c45b558e596653db751a2bfdd17b3b9ec"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages943fb58db0c212ba3a89378d1684f871e0e7783fc34fadc7696e5439c8c9338erpds_py-0.13.1.tar.gz"
    sha256 "264f3a5906c62b9df3a00ad35f6da1987d321a053895bd85f9d5c708de5c0fbf"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesd38cbabd90ebb61a8ce1ade0dc1f87e067287f7d97bf84d5ded1c4cc3fed5134s3transfer-0.8.1.tar.gz"
    sha256 "e6cafd5643fc7b44fddfba1e5b521005675b0e07533ddad958a3554bc87d7330"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
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