class HttpPrompt < Formula
  include Language::Python::Virtualenv

  desc "Interactive command-line HTTP client with autocomplete and syntax highlighting"
  homepage "https:http-prompt.com"
  url "https:files.pythonhosted.orgpackagesbfe2bc5b0df107afcac65fde7015df48cbe9b4d877d1d0818203544ed1a41d4chttp-prompt-2.1.0.tar.gz"
  sha256 "eee71a00fed0b8a2a35bb338b269be7a20e8a1a6f6465a65561d76a21521e7f3"
  license "MIT"
  revision 12
  head "https:github.comhttpiehttp-prompt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46c04a51a98a30cf89419af3cb9451e8e77fc07c7073ba55fbe4eb97cf189b9a"
    sha256 cellar: :any,                 arm64_sonoma:  "81f84f831dc105e50f1f728ac75295d4d7578c3548e273b0ff5d383ca67ea519"
    sha256 cellar: :any,                 arm64_ventura: "b16ff6d6a0e929e06e7b313e31d76bdb5b3deed58fe0789bffff804d5c369076"
    sha256 cellar: :any,                 sonoma:        "83bb2b5e2f453636747c09a9685f5fff1e602d6784927e4af7b32f4ccfae4dc7"
    sha256 cellar: :any,                 ventura:       "0138720ad89613031315237d087bb659ddd6c8cbd6a4a855d5b59dc40df26b4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1aaabc4d6a32d2bf63453ca1ab1a8a6f4dfbbc5368f1f9be6685f82a0b588a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc91e5f1f00b48530a123c24d565108f1e48cee2da7d715147d3cb585c0c067"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "httpie" do
    url "https:files.pythonhosted.orgpackages3ebbaefb0abbdbadeb9e8e7f04fb0f1942bc084f4215bf8dc729236153d09e1ehttpie-3.2.4.tar.gz"
    sha256 "302ad436c3dc14fd0d1b19d4572ef8d62b146bcd94b505f3c2521f701e2e7a2a"
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

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages912fa3470242707058fe856fe59241eee5635d79087100b7042a867368863a27multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "parsimonious" do
    url "https:files.pythonhosted.orgpackages7b91abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7parsimonious-0.10.0.tar.gz"
    sha256 "8281600da180ec8ae35427a4ab4f7b82bfec1e3d1e52f80cb60ea82b9512501c"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesc564c170e5b1913b540bf0c8ab7676b21fdd1d25b65ddeb10025c6ca43cccd4cprompt_toolkit-1.0.18.tar.gz"
    sha256 "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"http-prompt", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    require "pty"
    require "expect"

    test_url = "http:brew.sh"

    PTY.spawn(bin"http-prompt", test_url) do |read, write, _pid|
      read.expect(#{test_url}> )
      write.puts "get > test.html"
      read.expect(#{test_url}> )
      write.puts "exit"
      read.expect(Goodbye!)
    end

    assert_match(^<html>, (testpath"test.html").read)
  end
end