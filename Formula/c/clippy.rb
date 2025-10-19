class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "1f4fcb4c37e9988c744119990b6abe00dfdd85f45b1977d7d65eb4b78573100c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07790c935f68f67685f074913e6cf1533e52d586aed8b3df2ac61f30f3cf5d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84bcec864696f282ab59dc5df112b94e4df24975ac55b9476052b278f6634cac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d00caa8628cebf42b14c18c263cb2b8e3362331efd5c42d7e3a5597e85920b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "4636c8bdcd9b6fd07798764e725ffc14bcdf02782c81751f822b8e055ed4b3c5"
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