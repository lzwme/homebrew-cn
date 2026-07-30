class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://ghfast.top/https://github.com/autobrr/mkbrr/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "4618314638dff4a22bac14d208963750a17fc366f4aec4c5e31787c41977e922"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5538dd3558d1dd3ace502e90ef3e742f31003ea5112f154c18bd04b213b32c8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5538dd3558d1dd3ace502e90ef3e742f31003ea5112f154c18bd04b213b32c8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5538dd3558d1dd3ace502e90ef3e742f31003ea5112f154c18bd04b213b32c8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "140269e98bd3ccf78b5fa5b17e838b02cc9f651ec86e377ad7a4e18a14592322"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f75aa6f40d5f658898a3c2a7fc28ef73b1fcad53f23388a28b9eb5f09af14f"
    sha256 cellar: :any,                 x86_64_linux:  "e1f925a9627f6ed37e1ba4d63012f42ea9f02bf0d88885c47f2fd5052dae7de9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end