class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.17.tar.gz"
  sha256 "473b65fbdd3c363a460a45481b571c0d1329099c4f6f8d49da2340ed5d97c35d"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f9b55e76e0a0f419ce4b62e2aab5e59ac7e08a6fdf60f0711d9f93e398606a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05f9b55e76e0a0f419ce4b62e2aab5e59ac7e08a6fdf60f0711d9f93e398606a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05f9b55e76e0a0f419ce4b62e2aab5e59ac7e08a6fdf60f0711d9f93e398606a"
    sha256 cellar: :any_skip_relocation, sonoma:        "612dd789037da4a1d4168d46a4dc96054e66a34e5347d80402f93353fac844c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1979061a1531419d64422caf9b319667228766d193faf4f2092eb4a606d6ab7"
    sha256 cellar: :any,                 x86_64_linux:  "152acd80533dc9046f92c63ebf2c29ef0e405a96482d2b0c1b4bb5e3b0650e28"
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