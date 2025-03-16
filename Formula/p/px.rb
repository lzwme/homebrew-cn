class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px  ptop)"
  homepage "https:github.comwallespx"
  url "https:github.comwallespx.git",
      tag:      "3.6.7",
      revision: "fd13adf8defba0418efdb0dbdb7ce9df4be3d92a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4396edcf0b1021d6451d14e87c6eebac51b2603d344422afe05d047b24033ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4396edcf0b1021d6451d14e87c6eebac51b2603d344422afe05d047b24033ed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4396edcf0b1021d6451d14e87c6eebac51b2603d344422afe05d047b24033ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "045b254c4f66c7f5618b943ceff0bf8ea9a3e27046354034e16a826c9d738b03"
    sha256 cellar: :any_skip_relocation, ventura:       "045b254c4f66c7f5618b943ceff0bf8ea9a3e27046354034e16a826c9d738b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4396edcf0b1021d6451d14e87c6eebac51b2603d344422afe05d047b24033ed9"
  end

  depends_on "python@3.13"

  uses_from_macos "lsof"

  conflicts_with "fpc", because: "both install `ptop` binaries"
  conflicts_with "pixie", because: "both install `px` binaries"

  def install
    system "python3", "devbinupdate_version_py.py"

    virtualenv_install_with_resources

    man1.install Dir["doc*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}px --version")

    split_first_line = pipe_output("#{bin}px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end