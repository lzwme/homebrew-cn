class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https:github.comNike-Incgimme-aws-creds"
  url "https:files.pythonhosted.orgpackages6976a6c0e4d65438ef3b95099c919388fbdc617d89afb40e024ec2c22665e3d5gimme_aws_creds-2.7.2.tar.gz"
  sha256 "71526a98bd249bb3880cb2813817623d29ea880eaf260bbb5d1d366ccfae9474"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10e9aa13207535f3f2d9e8a00572f6ec7f4ea4c8f8295c074d6e52911b9def89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "551c6741a062df8510b1b236b0ad236c527c540d3719dfd83e1529ecb6ffe3b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45b4ac07092bf8843e09e2144e66e38309cf611b20ebe1f53917f00c06e948b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "02c5d14ab2640f8194223048bdec39c6fe5935c55e92b7ad17f69d74766f83c2"
    sha256 cellar: :any_skip_relocation, ventura:        "596a8b466c9f3f21fd10701102881bdb5f240846864a55f3b50aa7faf9469726"
    sha256 cellar: :any_skip_relocation, monterey:       "e0f169d48b0a8de2b7458e2d52a98f57311be18f183e02c6057f14e3825b4eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3b67e5b2339a61dfd506b0bc23aaec995219c0d770ab2f6d8d884d6eccc612"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  # Extra package resources are set for platform-specific dependencies in
  # pypi_formula_mappings.json, since the output of `bump-formula-pr` and
  # `update-python-resources` is impacted by whether command is run on macOS
  # or Linux. Remove if Homebrew logic is enhanced to handle this. Also,
  # occasionally check if any of these Python dependencies are no longer used.
  #
  # macOS: `pyobjc-framework-localauthentication`, ...
  # - gimme-aws-creds
  #   ├── ctap-keyring-device
  #       └── pyobjc-framework-localauthentication
  #           ├── pyobjc-core
  #           ├── ...

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages59ac01d0a0a231e9e11a4e2bfa86414e2d8acfd4755ecb1f3c5109dcb0906743boto3-1.34.62.tar.gz"
    sha256 "7373e50b97e27f55c5b2a15a095e7bb45a7d962ced4d1468650dced57087c56b"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages0435f0a45828aab5ac0056d948268c036857908512320510b66448821ae69e71botocore-1.34.62.tar.gz"
    sha256 "7e97e7237c50d50850fef0d2cc6c8c42965d236a13abf18b29e5b8bb427514d7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "ctap-keyring-device" do
    url "https:files.pythonhosted.orgpackagesc4c55c4ce510d457679c8886229ddbdc2a84969d63e50fe9fb09d6975d8e500ectap-keyring-device-1.0.6.tar.gz"
    sha256 "a44264bb3d30c4ab763e4a3098b136602f873d86b666210d2bb1405b5e0473f6"
  end

  resource "fido2" do
    url "https:files.pythonhosted.orgpackages746e58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4bfido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackagesa58aed955184b2ef9c1eef3aa800557051c7354e5f40a9efc9a46e38c3e6d237jaraco.classes-3.3.1.tar.gz"
    sha256 "cb28a5ebda8bc47d8c8015307d93163464f9f2b91ab4006e09ff0ce07e8bfb30"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackagesae6cbd2cfc6c708ce7009bdb48c85bb8cad225f5638095ecc8f49f15e8e1f35ekeyring-24.3.1.tar.gz"
    sha256 "c3327b6ffafc0e8befbdb597cacdb4928ffe5c1212f7645f186e6d9957a898db"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "okta" do
    url "https:files.pythonhosted.orgpackagese82a1c1bae7ed0b429cfe04caaff4ec06383669b651b315328b15f87ab67d347okta-0.0.4.tar.gz"
    sha256 "53e792c68d3684ff4140b4cb1c02af3821090368f8110fde54c0bdb638449332"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackages30728259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3bPyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyobjc-core" do
    url "https:files.pythonhosted.orgpackages50d50b93cb9dc94ab4b78b2b7aa54c80f037e4de69897fff81a5ededa91d2704pyobjc-core-10.1.tar.gz"
    sha256 "1844f1c8e282839e6fdcb9a9722396c1c12fb1e9331eb68828a26f28a3b2b2b1"
  end

  resource "pyobjc-framework-cocoa" do
    url "https:files.pythonhosted.orgpackages5d1d964a0da846d49511489bd99ed705f9d85c5081fc832d0dba384c4c0d2fb2pyobjc-framework-Cocoa-10.1.tar.gz"
    sha256 "8faaf1292a112e488b777d0c19862d993f3f384f3927dc6eca0d8d2221906a14"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https:files.pythonhosted.orgpackagesb088a7bab81887b3c65e89d91675c7af7cd7a6727e94daf352d39e1c73d8b1fdpyobjc-framework-LocalAuthentication-10.1.tar.gz"
    sha256 "e2b06bf7af1b6f8ba08bd59e1a3616732d801284362dd5482181b0b1488eca2d"
  end

  resource "pyobjc-framework-security" do
    url "https:files.pythonhosted.orgpackages04f9d105561be4172da0026ae5b1e85815efc3111f0e5e1be157a052218091bfpyobjc-framework-Security-10.1.tar.gz"
    sha256 "33becccea5488a4044792034d8cf4faf1913f8ca9ba912dceeaa54db311bd284"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name.start_with?("pyobjc") && OS.linux? }
    venv.pip_install_and_link buildpath
  end

  test do
    # Workaround gimme-aws-creds bug which runs action-configure twice when config file is missing.
    config_file = Pathname(".okta_aws_login_config")
    touch(config_file)

    assert_match "Okta Configuration Profile Name",
      pipe_output("#{bin}gimme-aws-creds --profile TESTPROFILE --action-configure 2>&1",
                  "https:something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "", config_file.read

    assert_match version.to_s, shell_output("#{bin}gimme-aws-creds --version")
  end
end