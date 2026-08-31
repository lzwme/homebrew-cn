class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/44/9b/d16174a31be5a77742bb25bf738d8d43b1adbc8f6f6f0bf91a7797bdc58d/gixy_ng-0.2.52.tar.gz"
  sha256 "6ff5f235d411d35eb8d4d33828389852ba4a27b77fbf0e1f49fd102e874afa78"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b964e89885dcf970a1af1832df48d97002b9f1a21cab9a7ab84b0a95e6e2748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfe5c238f333ed2a3702a22c4f864e97197ccfe663a4faf30833d1008a788af3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e805a78b14d0c28acbd6afed33870e0208f3f80b23d98fa188b6bb6cf9c8daa"
    sha256 cellar: :any,                 arm64_linux:   "f1116d1f1908d56f4af3c57a09113c02b6c1c529f17c01575b9b478162f53797"
    sha256 cellar: :any,                 x86_64_linux:  "cc6b5814c1e2fce82ea0f3f4e96bf1041cd4f629f6eb3a88d6e702ec0b57c74b"
  end

  depends_on "python@3.14"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3f/0b/30328302903c55218ffc5199646d0e9d28348ff26c02ba77b2ffc58d294a/configargparse-1.7.5.tar.gz"
    sha256 "e3f9a7bb6be34d66b2e3c4a2f58e3045f8dfae47b0dc039f87bcfaa0f193fb0f"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "ngxparse" do
    url "https://files.pythonhosted.org/packages/35/2e/b6247bc5ebaeb5a70c81c865451c140fa30d8c3a6e81598a659c0497e525/ngxparse-0.5.16.tar.gz"
    sha256 "33746d1693d93903ab0c2b37ba16b8a4743a2767b1959dc125a2417d253b7e3b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gixy --version")

    (testpath/"vuln.conf").write <<~NGINX
      http {
        server {
          listen 80;
          location / {
            return 301 http://$host$uri;
          }
        }
      }
    NGINX
    # Gixy exits non-zero when issues are found, hence the trailing `:1`.
    output = shell_output("#{bin}/gixy --format=json #{testpath}/vuln.conf 2>&1", 1)
    assert_match "http_splitting", output
  end
end