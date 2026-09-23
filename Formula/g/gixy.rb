class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/2c/38/9674c4446139e910b3fc9cc50facf84f47113dbffca11719ca49e4452e22/gixy_ng-0.2.54.tar.gz"
  sha256 "86066924574ae9f67e6ef1bd1f4ce336d29ad3f9329373b253f6cfc066a79606"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83bbb718b7a639c34b737bd7e3637f27c7c7e22bc81e2f214855120a7f9129d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3daf483debf336f9788662874a976554eba5e4ddbdacc596454379684a1a2c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1a6e6faf6d4ab9b78d42995c86b6059d9f4624aeed32c14623a7dde81295c46"
    sha256 cellar: :any,                 arm64_linux:       "4904309d26150b09be61ee39354b377b7b689ef6b906ae999a441f40ac9dda9f"
    sha256 cellar: :any,                 x86_64_linux:      "2d6f95ea446ff5bdb5120c70f81174a78d4ad0eb863b5538548feb95ea2625fa"
  end

  depends_on "python@3.14"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/9b/b4/7065677004d4ec8728da15a70580f431f1a4a079e0e8e8b7aa4ffee4e972/configargparse-1.7.7.tar.gz"
    sha256 "607bea276a219912158afa1e5a716c3f8f88d542f9997dfd43bbd0b492a9f5a6"
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