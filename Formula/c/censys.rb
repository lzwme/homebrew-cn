class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https:github.comcensyscensys-python"
  url "https:files.pythonhosted.orgpackages086976c19cff1cac71420eb731300f39bbba90308a23a8bca9bd6a6d5bafdeffcensys-2.2.16.tar.gz"
  sha256 "c70680ee84630fba20c3d14f1ed0d9c2a5a2d54009d0821fbaa9fed8119c4ee3"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd2e27b67a7a06074480fb76a6c29677d9c9273d9201442fccf754cef95dbd2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd2e27b67a7a06074480fb76a6c29677d9c9273d9201442fccf754cef95dbd2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd2e27b67a7a06074480fb76a6c29677d9c9273d9201442fccf754cef95dbd2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdbbb9350f17a4b3bca071916c6013db8a707ea8d33d9584c51425cb4ed1a616"
    sha256 cellar: :any_skip_relocation, ventura:       "bdbbb9350f17a4b3bca071916c6013db8a707ea8d33d9584c51425cb4ed1a616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c9f92799d176079c540ba1bc64c8af60234b9231c0ba65f79e5a3482d721e04"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7f03581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesaa9e1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}censys --version").strip
    assert_match "401 (Error Code: unknown), Unauthorized", pipe_output("#{bin}censys asm config 2>&1", "test", 1)
  end
end