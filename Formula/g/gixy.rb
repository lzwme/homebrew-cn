class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/dc/83/e7454baaa6db43cfde942d583f81b8537faab7cbc5d683e83a15731628a4/gixy_ng-0.2.57.tar.gz"
  sha256 "7feabc25746e12ad6f7b3dd5b1de09bd588986c174ad199a3ad975270697a588"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e5ebed7ab4cb2b5bc64871e7902b3b64f93b1df4447b33e6b56d365b90ed164"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a9e9198e35c2e56ab1650a746c9e45a118982f5aaedb6de841ba581abe98e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc2194ce9f4856642ef7f4d2c96a29e1b77c58bd87e1990f179a598f76c1fbf5"
    sha256 cellar: :any,                 arm64_linux:       "ce3ef7ace981dba440902a2501e984ca18ab4f3a99931302feb20b3c89e8f6be"
    sha256 cellar: :any,                 x86_64_linux:      "68be69f6d5aaeda2f90b8f251061babb359ccd37a74c2c7319617078aff964cd"
  end

  depends_on "python@3.15"

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/5d/ed/33c0ba7f0b5be384ff8a2101ce77728f219e816b2104819f1651477e1ad5/configargparse-1.8.0.tar.gz"
    sha256 "22a417f4d7b00149f0af82ef7c491f8ecc4b1d5454633fd319b386f5eb806f92"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
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