class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px  ptop)"
  homepage "https:github.comwallespx"
  url "https:github.comwallespx.git",
      tag:      "3.5.1",
      revision: "53c4faf6708a89d5dd07ac5b994b42e4ae4164b2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1a13b827a808c186334d9eb3183479e00cef36b0977622111b503829766b38e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1dca70a0b59ca2bbd4b693915e03dcaf6f7459cf5fc19f6ed628adce4271ac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c310a38e87a8529fd8083a2e57011f7cb5e848f43e3d2b038558decda8963ba6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d3008973740d77bb65e76164c418c315ef8cc9bcef39db297a00fceff7925fb"
    sha256 cellar: :any_skip_relocation, ventura:        "6b4d01ab77ebb39e5713b9a45ba155a65bf8b62bc7b66a5965908dd1f8708381"
    sha256 cellar: :any_skip_relocation, monterey:       "e7ef581b3b0a791a762405280d3fc7cee8f7a3967d69d54458835b11c6bbf39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033014ab4f8380d93c3e68b8ba227ef9c635dab3ebd20f5d600880e7062af53f"
  end

  depends_on "python@3.12"

  uses_from_macos "lsof"

  def install
    virtualenv_install_with_resources

    man1.install Dir["doc*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}px --version")

    split_first_line = pipe_output("#{bin}px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end