class Jqp < Formula
  desc "TUI playground to experiment and play with jq"
  homepage "https://github.com/noahgorstein/jqp"
  url "https://ghfast.top/https://github.com/noahgorstein/jqp/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e88b32aeb21b8d000e17619f23a0c00a1eb86219112204031f63fb7cdfafacf0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92566027d91cd63e3b3f0d31c62381330ac6c8c1c944831a3fdc5308c9532ab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92566027d91cd63e3b3f0d31c62381330ac6c8c1c944831a3fdc5308c9532ab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92566027d91cd63e3b3f0d31c62381330ac6c8c1c944831a3fdc5308c9532ab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e199de504b616c1b56b8ecbc62e83cd6bdca0ab5e069705dbd141435d721ed91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96c9c531b034f344c1c55120312b9664cc09d1aea6364042f84abda6cfe3edd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jqp --version")

    # Fails in Linux CI with `open /dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Error: please provide an input file", shell_output("#{bin}/jqp 2>&1", 1)
  end
end