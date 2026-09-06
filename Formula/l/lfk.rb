class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.8.tar.gz"
  sha256 "ea63a7efa1d1b2169b0928a6b692d1984ae0ca7516b3837318c30cf0a88500af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b296b0c2c173a4f451632627c54caa8ebb623224ae9cacfbe7bbc22f6b418ed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "147bbcce9745b40460c2f714a9509a9b7218ee1e846583a2664ff7c51ed28493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c2f6fc7ca048e20ab840115367e95cca790d038c9a17f600c453d0cc6df8fc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83c1bc282b14d5afaf3490bbe544809be103964b0ff24f534b98bf222f109808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b02ad4c0ed2a4a8c95b9cfd7faef7713394f1a88742d9478d64b49750fdd1a4b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end