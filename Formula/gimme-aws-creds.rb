class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/fe/01/cdf8901f4c2a3f17974811e1e6669e655f7401111fa033bf07e5192086bd/gimme%20aws%20creds-2.7.0.tar.gz"
  sha256 "a290e0de76c231a923c59fd2d7422331a94f64920aa972971d2c8ece7c461a23"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "cb0deca43878572ce331664986cabdf2b332c8707a05b5eca3290d479aca3acf"
    sha256 cellar: :any,                 arm64_monterey: "34bc194656f95126214295d6bd21b27723f8f74671a3f6e6831d2038642e3222"
    sha256 cellar: :any,                 arm64_big_sur:  "a1b70f524e0efe908b92bc93187eb8bed47e1eb6970fecb9ed55c364b1f79700"
    sha256 cellar: :any,                 ventura:        "77a3fedbd2904370404e2b167388be39c8233b49f8ab8e4c28323eee0fe3930d"
    sha256 cellar: :any,                 monterey:       "33a4ef40914e8bd0445db480de5776e7783c9ffe1fe32f62e089be254b84c2b8"
    sha256 cellar: :any,                 big_sur:        "8945409e815f547a190c064c9225d4386b089e8f8aefbb2db31faed76f53bdbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f545c30082d7cd4d4772c0018e4429de48cdaedfac0c88d55c61a74002801ae6"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Extra package resources are set for platform-specific dependencies in
  # pypi_formula_mappings.json, since the output of `bump-formula-pr` and
  # `update-python-resources` is impacted by whether command is run on macOS
  # or Linux. Remove if Homebrew logic is enhanced to handle this. Also,
  # occasionally check if any of these Python dependencies are no longer used.
  #
  # Linux: `jeepney`, `SecretStorage`
  # - gimme-aws-creds
  #   ├── keyring
  #       ├── jeepney
  #       └── secretstorage
  #
  # macOS: `pyobjc-framework-localauthentication`, ...
  # - gimme-aws-creds
  #   ├── ctap-keyring-device
  #       └── pyobjc-framework-localauthentication
  #           ├── pyobjc-core
  #           ├── ...

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/f9/889e0c7d07bc5616d193d63b9600145d2d83f21a09fca40be078ef9323eb/boto3-1.28.17.tar.gz"
    sha256 "90f7cfb5e1821af95b1fc084bc50e6c47fa3edc99f32de1a2591faa0c546bea7"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/54/ce/3aced9653aa3b81aeda70574f342cd3014ecc36aff6a20e74c767f92864f/botocore-1.31.17.tar.gz"
    sha256 "396459065dba4339eb4da4ec8b4e6599728eb89b7caaceea199e26f7d824a41c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/8e/5d/2bf54672898375d081cb24b30baeb7793568ae5d958ef781349e9635d1c8/cryptography-41.0.3.tar.gz"
    sha256 "6d192741113ef5e30d89dcb5b956ef4e1578f304708701b8b73d38e3e1461f34"
  end

  resource "ctap-keyring-device" do
    url "https://files.pythonhosted.org/packages/c4/c5/5c4ce510d457679c8886229ddbdc2a84969d63e50fe9fb09d6975d8e500e/ctap-keyring-device-1.0.6.tar.gz"
    sha256 "a44264bb3d30c4ab763e4a3098b136602f873d86b666210d2bb1405b5e0473f6"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/74/6e/58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4b/fido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/14/c5/7a2a66489c66ee29562300ddc5be63636f70b4025a74df71466e62d929b1/keyring-24.2.0.tar.gz"
    sha256 "ca0746a19ec421219f4d713f848fa297a661a8a8c1504867e55bfb5e09091509"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/b7/56/7daf104a9cb6af39c00127aee6904b01040dbb12cf1ceedd6a087c097055/more-itertools-10.0.0.tar.gz"
    sha256 "cd65437d7c4b615ab81c0640c0480bc29a550ea032891977681efd28344d51e1"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/e8/2a/1c1bae7ed0b429cfe04caaff4ec06383669b651b315328b15f87ab67d347/okta-0.0.4.tar.gz"
    sha256 "53e792c68d3684ff4140b4cb1c02af3821090368f8110fde54c0bdb638449332"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/48/d9/a13566ce8914746557b9e8637a5abe1caae86ed202b0fb072029626b8bb1/pyobjc-core-9.2.tar.gz"
    sha256 "d734b9291fec91ff4e3ae38b9c6839debf02b79c07314476e87da8e90b2c68c3"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/38/91/c54fdffda6d7cfad67ff617f19001163658d50bc72376d1584e691cf4895/pyobjc-framework-Cocoa-9.2.tar.gz"
    sha256 "efd78080872d8c8de6c2b97e0e4eac99d6203a5d1637aa135d071d464eb2db53"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/c4/56/0633d26535306ba989d0857f03192b43d6f7d609651e92ffe5091a79639e/pyobjc-framework-LocalAuthentication-9.2.tar.gz"
    sha256 "088f102e61efe860b71ac46449c1ea2cfa17f76a71db6fb9e2f5df1df56d0dd6"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/57/52/64bbefd489f51ab2681326777c77f6bafa48948c60774311e428e21fc0d1/pyobjc-framework-Security-9.2.tar.gz"
    sha256 "8d4f7a22db2fe666c7bff4a5825b49d2345e9a8d96ea085f1a614ad9a559b4e5"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/9e/780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91/soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
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
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    venv = virtualenv_create(libexec, "python3.11")
    res = resources.to_set(&:name)
    if OS.mac?
      res -= ["jeepney", "SecretStorage"]
    else
      res.reject! { |r| r.start_with? "pyobjc" }
    end
    res.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
  end

  test do
    # Workaround gimme-aws-creds bug which runs action-configure twice when config file is missing.
    config_file = Pathname(".okta_aws_login_config")
    touch(config_file)

    assert_match "Okta Configuration Profile Name",
      pipe_output("#{bin}/gimme-aws-creds --profile TESTPROFILE --action-configure 2>&1",
                  "https://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end