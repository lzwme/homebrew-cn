class Ldeep < Formula
  include Language::Python::Virtualenv

  desc "LDAP enumeration utility"
  homepage "https:github.comfranc-pentestldeep"
  url "https:files.pythonhosted.orgpackages35a552af77c7a347757c9890dcfbb10f5e13e8ef778dbc2cb8ff18cfc66c462eldeep-1.0.56.tar.gz"
  sha256 "bff4b348eecc80f307771cc0d49ec2f497430bdda9fbb78252455ade4c35eb00"
  license "MIT"
  head "https:github.comfranc-pentestldeep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af4a0c38d15a5a05033eae9238b8279d82e56c21c7ffe0088d32b865bb4c755c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "748d40485d97afea26fdf9f940e67443b2db0875b11d86dadf27dbe0cb269f5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4c0712ef59a318c82fe9ee2a385d9cb5ac2980cbe92c6250584e7c100a7518b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8465bc04922b7e02ef74f11324b40494060c6a20e08dd7365526aecf609aaea"
    sha256 cellar: :any_skip_relocation, ventura:        "e68d6c1279a96589e1dbdeef4c257c67f10514ca9af4e0173781b809e71e00dd"
    sha256 cellar: :any_skip_relocation, monterey:       "17831ed678e34cdfcae13580eb843ce6eb5d12bbd6c80074f7a7e236c940af2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1329833a5d423e95a4c6dd4f7e01c8e37af2c374c17e345e238928fbd5ec700"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "krb5"

  resource "asn1crypto" do
    url "https:files.pythonhosted.orgpackagesdecfd547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6eeasn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "commandparse" do
    url "https:files.pythonhosted.orgpackages796b6f1879101e405e2a5c7d352b340bc97d1936f8d54a8934ae32aac1828e50commandparse-1.1.2.tar.gz"
    sha256 "4bd7bdd01b52eaa32316d6149a00b4c3820a40ff2ad62476b46aaae65dbe9faa"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "gssapi" do
    url "https:files.pythonhosted.orgpackages13e7dd88180cfcf243be62308707cc2f5dae4c726c68f30b9367931c794fda16gssapi-1.8.3.tar.gz"
    sha256 "aa3c8d0b1526f52559552bb2c9d2d6be013d76a8e5db00b39a1db5727e93b0b0"
  end

  resource "ldap3" do
    url "https:files.pythonhosted.orgpackages43ac96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "oscrypto" do
    url "https:files.pythonhosted.orgpackages0681a7654e654a4b30eda06ef9ad8c1b45d1534bfd10b5c045d0c0f6b16fecd2oscrypto-1.3.0.tar.gz"
    sha256 "6f5fef59cb5b3708321db7cca56aed8ad7e662853351e7991fcf60ec606d47a4"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages31a4b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages1056d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages5ac0b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  # add missing VERSION file, upstream pr ref, https:github.comfranc-pentestldeeppull78
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}ldeep ldap -d brew.ad -s ldap:127.0.0.1:389 enum_users test 2>&1", 1)
    assert_match "[!] Unable to open connection with ldap:127.0.0.1:389", output
  end
end

__END__
diff --git aVERSION bVERSION
new file mode 100644
index 0000000..ed453e6
--- devnull
+++ bVERSION
@@ -0,0 +1 @@
+1.0.56
diff --git apyproject.toml bpyproject.toml
index fcb3ac1..8b58514 100644
--- apyproject.toml
+++ bpyproject.toml
@@ -45,6 +45,12 @@ Homepage = "https:github.comfranc-pentestldeep"
 [project.scripts]
 ldeep = "ldeep.__main__:main"

+[tool.pdm.build]
+includes = [
+    "ldeep**",
+    "VERSION",
+]
+
 [tool.pdm.version]
 source = "call"
 getter = "ldeep:get_version"