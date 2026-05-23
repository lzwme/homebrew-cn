class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.19.tar.gz"
  sha256 "92bb2b0ab5235372ddae83c8bebe9bda80cc9eac486b1c95581a8426b7b2cfd7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fc2d71c4d3f16d93d9f531ef6b2b4f9efdf07846716754d371e5526312086b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc2d71c4d3f16d93d9f531ef6b2b4f9efdf07846716754d371e5526312086b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fc2d71c4d3f16d93d9f531ef6b2b4f9efdf07846716754d371e5526312086b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a9952b9c6fb90894671ec6c0fb41d9b9672b65ac3d87512200b0081aeda47c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc1758047800fca238fc128bd0f6c39b37cf864722df60fea0bb8c52a5636f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c102a9ea71bf1c560f34ad917754b41a70a5f9b8f36e9dbb68ba4b09f06e87"
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