class Gixy < Formula
  include Language::Python::Virtualenv

  desc "NGINX configuration static analyzer focused on security"
  homepage "https://gixy.getpagespeed.com/"
  url "https://files.pythonhosted.org/packages/9e/2a/b9ba8bb796a3c7199f1f4499c9a289e491894c36aa923e03cbdd90b4a6d8/gixy_ng-0.2.59.tar.gz"
  sha256 "6f49c0507c04acc7ac50b1f2455cd625b29a039d9ddca49b7c9f20603a501bca"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8036c0d68b103946d3c89cc0537efdd465872a38e15ab28890644d67a72628c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06faf7ace77106cfdd7923f17083263857d27aaeb1f53257991f4d098e0d1c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9cb129766eed03999a9c00124918ec4ed0281502c4c8cc49f1babac617fa02db"
    sha256 cellar: :any,                 arm64_linux:       "6e76efeccf4273ae9e3fc7fcf01a6511701963fb2810bf71303e52d2e83989e6"
    sha256 cellar: :any,                 x86_64_linux:      "e62ec499ab9636defb94a2439e427f471ff55c5a1a2e76a9d527551e623b2bce"
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