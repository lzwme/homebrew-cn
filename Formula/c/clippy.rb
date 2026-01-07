class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "765ad9b55bd27e36e762beeef19b31ee5f5b465b5012bedc7dacaee1c665ef49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5779cb64172c5371b30bf8f6ce91c61a420b573a3d75835ec758dfc176f8cd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e5581cd6e472b37ac0039f4a6af7d8bf5e7970e04267a4e2e63e498ae90130d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab52dbf0f21aa7222e3ec7094d18fc6dbf7be576547776c0af3a44ffa6e3f421"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4375e6b78c836a40f1a356c1f2c80b8a17470e5d5acc79fc0aaaf03561a684c"
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