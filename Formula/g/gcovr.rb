class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/47/12/460c5d026ea8877cade21473e090a125288442ff930cd08bdf5e3f9eb194/gcovr-8.5.tar.gz"
  sha256 "9f0e21aab72b70fc26a4a0b6e35f25b97eefb5ce6e9c57388bf4a065726f7965"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "987ff0c69f40efff1a75416a8df8b685de88d804b6abd1f999841189e98b5288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6b10244e902e6ca3f0846b4094f13214807bd849496c49550e855d6bc7e674e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f87abec3e99472b6c36aa772deab78aebc214f23362f591ce9d6e1e1d68071"
    sha256 cellar: :any_skip_relocation, sonoma:        "0302bf151507a54b5282c7c6b39f74f3f39cc712b5b9262dbde3a8ffab199397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08ee045705e83170f6aad7c82e870e38799c2753163d46ae356f0fc991d7c689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d8d0dcd8f16b74d82f6032f3379a073b4d77b3b079dc0c8e1273dd03114e6f9"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/a2/61/f083b5ac52e505dfc1c624eafbf8c7589a0d7f32daa398d2e7590efa5fda/colorlog-6.10.1.tar.gz"
    sha256 "eb4ae5cb65fe7fec7773c2306061a8e63e02efc2c72eba9d27b0fa23c94f1321"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write <<~C
      int main() {
        return 0;
      }
    C

    # gcov must match the c compiler version, which is gcc-12 on linux
    ENV["GCOV"] = ENV.cc.sub("gcc", "gcov") if OS.linux?
    system ENV.cc, "--coverage", "-g", "-O0", "-o", "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr")
  end
end