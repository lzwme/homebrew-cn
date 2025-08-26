class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/c9/ce/51f7b53a8ee3b4afe4350577ee92f416f32b9b166f0d84b480fec1717a42/pwncat-0.1.2.tar.gz"
  sha256 "c7f879df3a58bae153b730848a88b0e324c8b7f8c6daa146e67cf45a6c736088"
  license "MIT"
  head "https://github.com/cytopia/pwncat.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "c253e09b178311523ba3d2049c83ee52bdfb56f6544030d4caab4146d7e43d58"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end