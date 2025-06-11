class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https:github.comcensyscensys-python"
  url "https:files.pythonhosted.orgpackagesf3db89a2a0709deeca690bee2bc77cb330c87f8bd2c41b7d8dfa2e5880048da6censys-2.2.17.tar.gz"
  sha256 "da07d8589fc98b8878eec5772d275d199dda89a3340ce69cd6ab2dc5567e887f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3700a636ba00613846ab7187a1e09667e95601b8fd872bbe2bbfadc57cba399d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3700a636ba00613846ab7187a1e09667e95601b8fd872bbe2bbfadc57cba399d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3700a636ba00613846ab7187a1e09667e95601b8fd872bbe2bbfadc57cba399d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c8ca67692b25e3bb01d9898e4101f8b24921c36ab12e427f67c85e5d253c36c"
    sha256 cellar: :any_skip_relocation, ventura:       "5c8ca67692b25e3bb01d9898e4101f8b24921c36ab12e427f67c85e5d253c36c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8fdc980f9766e9acc4382019f24a45dd235709c180ad37e902978f2700dba44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fdc980f9766e9acc4382019f24a45dd235709c180ad37e902978f2700dba44"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages160f861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
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
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec"binregister-python-argcomplete", "censys",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}censys --version").strip
    assert_match "401 (Error Code: unknown), Unauthorized", pipe_output("#{bin}censys asm config 2>&1", "test", 1)
  end
end