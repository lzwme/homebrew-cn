class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.4.2.tar.gz"
  sha256 "c4f92c80ea3381f676318c9a096e004741588d81e06bb3d85181c1a12c18417f"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11a5c2d289ff87a10d245cdd92f82e865b4ffbbf1b662b5a9767a02ceb26c3e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fd7d6d1c63d0e5df961ba755a74447a36e832509e2cf37b12e75ee2505b80a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a66fb316133f3042475c32d39e6a2f5cb05f21964a621bc1a43d179287a42f52"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a3bfa5bb56198f88c74466529eb66c1c6d32d7fd3b970562ee6f49c993c007a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "717e9d602ad8e30f20147c610c2ffc037ee77c7508aa28cfb08e6dbb498fa4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc55d84a798f0fdc64fb51be65eb3a9c2b2dc47aeb181c1269f901cd3ea15ca3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end