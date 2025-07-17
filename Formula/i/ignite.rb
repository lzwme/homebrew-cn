class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://ghfast.top/https://github.com/ignite/cli/archive/refs/tags/v29.2.0.tar.gz"
  sha256 "7c9e5d0c6ae32549ac32d6f4aae5f53f6116ceacca707e06e8bcf3786d125053"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a64e3e4067a95dced9fbe72c7176032ff88eba40cf56cf0dc43cc826cd8d380d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d84f14a8a74811f755cec414833145c970c07cd311e8046c52ace27f56f12c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a594ec537694b56734a37b1a9bc1ca596a0f14e180a1d645ff4267024de21a55"
    sha256 cellar: :any_skip_relocation, sonoma:        "60831e7176d00195caf2dfbecf8514171c2f8d1e242d069a736ce5751ab692b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "472af9c323bb64d1e7f9722680ae29ca63a83805654c0e0b9fc2ea6353671b3f"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end