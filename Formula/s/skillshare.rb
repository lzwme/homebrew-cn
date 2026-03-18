class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "85eb61c12b729059d7832dafefaccdc4780509ed2080f0b9adff0f22474a1144"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec1bdcf532ec51c0b312492a2e7a281fb4a21c526f69efb79bae428c11864e20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1bdcf532ec51c0b312492a2e7a281fb4a21c526f69efb79bae428c11864e20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec1bdcf532ec51c0b312492a2e7a281fb4a21c526f69efb79bae428c11864e20"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c0558f685e9d2b33bf92089d5829efb7d8ec024288f1224068444087bbd652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f20a977c6008c48e12d973a97bb4eac786aba6d8b00ec07c3ee759c4b0bff50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ebe4b7075f977b97574416f71a0f8b0457c3c6fe602935a8e2f6184ca770362"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end