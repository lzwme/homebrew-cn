class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.9.2.tar.gz"
  sha256 "e5de37fd304ff1fd671f892a6642b9a28dfa104756ef97ef6df6aedbdf5927ec"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a574737a4a1828990e03c8a3f23f02d58a9d449b72013a71bca1905f47c0726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9bf20f6485c58a020c396276ed34482bcc3698927e4aa52bd0b08cd44f6c749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a94b61d583a0e4d3a68dea11f3c42ce6d6a532d8f6deff95d02e7c73773b1530"
    sha256 cellar: :any_skip_relocation, sonoma:        "61ad9f1644d3d4a816f9a3c1353c896f46876817afc403880f616765d33089bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2d68410f10da20fc65a523e5cbe85e8d5286a9b7340a4bff4fe6addfcb272f5"
    sha256 cellar: :any,                 x86_64_linux:  "ee33f1d6b70093972a622d48335991f965f6df0d704ed27c8cdfb4e0de060165"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
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