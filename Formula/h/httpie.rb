class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https:httpie.io"
  url "https:github.comhttpiecliarchiverefstags3.2.2.tar.gz"
  sha256 "01b4407202fac3cc68c73a8ff1f4a81a759d9575fabfad855772c29365fe18e6"
  license "BSD-3-Clause"
  revision 7
  head "https:github.comhttpiecli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71ca4ea3a7b53f0c2d2d7d6c88fa7c08986538fca935a1de9de4c3e56e372c8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba449306f2e31520e54027770989b8dd061ef8c1c7e01f78a02f5dfd00e070a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d00f3a846786c3b046620dff7bb7ed75f30bb02f3cb1c93655760ff897684310"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9a9ae39f5e6e7c76f40daa28379460840f58904b9a3ab2ca5cde5e21d673d8e"
    sha256 cellar: :any_skip_relocation, ventura:        "633cb8595246206f68428de8946e60ad2423e73799ca2173096fdc7bb2109ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "742e8ce4cbd9a88e9b1710aa6135a2cada0b8424493869fdc5b335d42239e781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ca6608d999f198ce11e7f4201f22c5494b1c33182ef6f2406abdf67e4f6f5f"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages86ec535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392dbrequests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesaa605db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    # We use a special file called __build_channel__.py to denote which source
    # was used to install httpie.
    File.write("httpieinternal__build_channel__.py", "BUILD_CHANNEL = \"homebrew\"")

    virtualenv_install_with_resources(link_manpages: true)

    bash_completion.install "extrashttpie-completion.bash" => "httpie"
    fish_completion.install "extrashttpie-completion.fish" => "httpie.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}httpie --version")
    assert_match version.to_s, shell_output("#{bin}https --version")
    assert_match version.to_s, shell_output("#{bin}http --version")

    raw_url = "https:raw.githubusercontent.comHomebrewhomebrew-coreHEADFormulahhttpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}http --ignore-stdin #{raw_url}")
  end
end