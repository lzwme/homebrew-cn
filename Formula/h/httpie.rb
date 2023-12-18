class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https:httpie.io"
  url "https:github.comhttpiecliarchiverefstags3.2.2.tar.gz"
  sha256 "01b4407202fac3cc68c73a8ff1f4a81a759d9575fabfad855772c29365fe18e6"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comhttpiecli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b1b8037c23ceac918bb7adb21a505e7c35ea1121e9f26019e27cb16e8e9faf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25a61b5fa9d83aa508a3761e4fd2058ee340603e3a7c5a91c28b1fc8dddea267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e9d80ba6d23aaac9e25cafa1e522f1a62bb87995ad68ca955e25c32934b31b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea0705e403cb2ca26788f28e2554dae49b22ff0636b1fea8613782eb30e14248"
    sha256 cellar: :any_skip_relocation, ventura:        "0105a15d0bdacde54eec24354ef7788ec9eccbb08af43ee767bb2812753ee159"
    sha256 cellar: :any_skip_relocation, monterey:       "bb9d5a84e79700b806b6135015281a2087148976cda22306c6c5d91fb9f3cef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65c47be216a323dc3eef8f4c4ff5dc26d7f418eb80cc4aab2eb47b492e25644b"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb10ee5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    # We use a special file called __build_channel__.py to denote which source
    # was used to install httpie.
    File.write("httpieinternal__build_channel__.py", "BUILD_CHANNEL = \"homebrew\"")

    virtualenv_install_with_resources

    man1.install_symlink libexec"sharemanman1http.1"
    man1.install_symlink libexec"sharemanman1https.1"
    man1.install_symlink libexec"sharemanman1httpie.1"

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