class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/a1/d8/364987b50a3769063404e93babe664589f9899f621a367e05a69714dd997/urlscan-1.1.0.tar.gz"
  sha256 "f7a8abdee47fbb62dee2d2484f526bb14d514d184a617ff98bd41d1102e59c35"
  license "GPL-2.0-or-later"
  head "https://github.com/firecat53/urlscan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c4213d6544477dcc258e656587c5f03807e732c92aa5364695b7cf36e9628f1"
  end

  depends_on "python@3.14"

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/79/ea/0a61a054016f6592ac9a430723bdbcedbbca9630a2781e70d2df189afe84/urwid-4.0.9.tar.gz"
    sha256 "99bad59b4c7b5bf87bd86196be4554ef93a031947f2a84f0fb090d8162b6ffc5"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end