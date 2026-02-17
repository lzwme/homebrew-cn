class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "15afa6dd8bbe5216a314a8431213a969a3a2003c1584d35ed0cd6d3fcb8fdee8"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b80592f5094ea650677e7ae4f277697b351c5fdf8e23efb29ad20e5cab6498ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b80592f5094ea650677e7ae4f277697b351c5fdf8e23efb29ad20e5cab6498ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b80592f5094ea650677e7ae4f277697b351c5fdf8e23efb29ad20e5cab6498ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9e309c9fee86097e7a5406f4e7f7fea7446f728a1b0c78ec8ac25d1a5d9884d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99f12bbcf96bdc9d5f41cde44a1e167540566123a2b4ed1410150bc48787bedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6033ba1d433d208e2296b150c8c37fa4202ba98271bbc3f989c756ff59cf0b00"
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