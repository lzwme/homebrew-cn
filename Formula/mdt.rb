class Mdt < Formula
  desc "Command-line markdown todo list manager"
  homepage "https://github.com/basilioss/mdt"
  url "https://ghproxy.com/https://github.com/basilioss/mdt/archive/refs/tags/1.2.0.tar.gz"
  sha256 "fe8d1cb2b5818895cf1b514dd8f76bb28fcb9aab6178acbf4615a07f690c7f15"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3dcc98427000e57158014eaca28a0d4e71ed84189b4d9027cc4fa463d2db03c9"
  end

  depends_on "gum"

  def install
    bin.install "mdt"
  end

  test do
    assert_equal "mdt #{version}", shell_output("#{bin}/mdt --version").chomp
    assert_match "Error: Got an unexpected argument '--invalid'.", shell_output("#{bin}/mdt --invalid 2>&1", 1)
  end
end