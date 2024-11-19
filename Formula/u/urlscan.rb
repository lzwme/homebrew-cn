class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "Viewselect the URLs in an email message or file"
  homepage "https:github.comfirecat53urlscan"
  url "https:files.pythonhosted.orgpackages5e110610ca7763c958555688edac109cba92bd5b71bc42af7b8eeacafff0c96eurlscan-1.0.4.tar.gz"
  sha256 "622bfa957615633f8c0b931b8e131b6cfcc5b843ccca75f89927468870ee0e8e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "724122478fcb0e78dcf6ce8de139bbdf25fd20a5d18995b6ddb6ed131eca04f4"
  end

  depends_on "python@3.13"

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urwid" do
    url "https:files.pythonhosted.orgpackages9821ad23c9e961b2d36d57c63686a6f86768dd945d406323fb58c84f09478530urwid-2.6.16.tar.gz"
    sha256 "93ad239939e44c385e64aa00027878b9e5c486d59e855ec8ab5b1e1adcdb32a2"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    man1.install "urlscan.1"
  end

  test do
    output = pipe_output("#{bin}urlscan -nc", "To:\n\nhttps:github.com\nSome Text.\nhttps:brew.sh")
    assert_equal "https:github.com\nhttps:brew.sh\n", output
  end
end