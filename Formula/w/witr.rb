class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "c01712b004126e20af815558442b82adbd4c133a179848e1274bc66a10dcd06b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "895a89f06b6e973a43334826dd3ef64d1ef29d524f5f21b8ad75180e28ea84ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72485153439189a01072a5e6bf6ef9ec94fe777fa7e49d99268044fcf7031b6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec09813e688affe70af706920173a4fb0b56f0bd59e04a0d02567dd2b0c6d5da"
    sha256 cellar: :any_skip_relocation, sonoma:        "04852f34f673d6c65f6888124d4ae708d97b85ac5776172dfbae26c9cf9acbaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49a60f6720df4b7aab5636ce1e99f1a705b794d2b8c0e989c0c144056cfbd12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db19963b76a05d83ef691ece1e299bfb42dc1655c213d8efd8fee55fcac6c5f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end