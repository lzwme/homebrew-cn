class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "76eec78695e934e7867bea8fb97eb3ce5a00170e9bc36f8ee3640337289f310c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "634a07ad6e8af565aa25297f731ce62538df9fb61b184d1152b2eab2c5a86ecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fd4e7f1d427c2b9f158f1760f86af2627650ba9d27899a4bcf24e060da57219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5cf4787e3b66d18309aff5388366d83aa85ab9cb4b8a029ae605de9a3d0d579"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a5abade006f450b278fbc3f56c21055decd2588b6d4c8bd1e6bf6c03ee867bd"
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

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end