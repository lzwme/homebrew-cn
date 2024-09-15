class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px  ptop)"
  homepage "https:github.comwallespx"
  url "https:github.comwallespx.git",
      tag:      "3.6.5",
      revision: "837bd0e16a0abfd4a315f7d240d6227a6b861e07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f01f55912fe2c6b625844c3c511d3e922021a61c3739867fc2b977dd3e4b466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f01f55912fe2c6b625844c3c511d3e922021a61c3739867fc2b977dd3e4b466"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f01f55912fe2c6b625844c3c511d3e922021a61c3739867fc2b977dd3e4b466"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f931b1bdc8604a0fa2c22649f0da98dbbe7e513b80d601fe01a17b4621337da"
    sha256 cellar: :any_skip_relocation, ventura:       "9f931b1bdc8604a0fa2c22649f0da98dbbe7e513b80d601fe01a17b4621337da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f01f55912fe2c6b625844c3c511d3e922021a61c3739867fc2b977dd3e4b466"
  end

  depends_on "python@3.12"

  uses_from_macos "lsof"

  conflicts_with "fpc", because: "both install `ptop` binaries"
  conflicts_with "pixie", because: "both install `px` binaries"

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