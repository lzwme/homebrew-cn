class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "c2b6bf932a52387c1bb459735414b287e8deeac9d829dbdab14bbae40ec439b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "301de74e47814462e31a35e9a214030a48e2c1e3a021caa4f14a24431dfbe0e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0009f058340a7082621eff60d065f061737de3fd1b2d6b6d97b837b482d2c15c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec9debcbab4ff8f7f380f7d29e7f42d65a35af49fb21aa769604a932610a1f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e73aeb0fc5946b6278d77b808eb324793cd2a622a90a29f19cd2883bd04b5bd3"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end