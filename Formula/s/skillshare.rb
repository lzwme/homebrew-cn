class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "0268506ee4f5e46e53291a27bf7bed30b02ca55e18aa2da6fb2f5f40ea03b9e5"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab7f0e4d27128bcedd4b0f27da24b8607703942023c9b2338f7109c6ba207ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab7f0e4d27128bcedd4b0f27da24b8607703942023c9b2338f7109c6ba207ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab7f0e4d27128bcedd4b0f27da24b8607703942023c9b2338f7109c6ba207ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "611b2b3270af35972eac7e008a019f9df222e1e6e04d08fdf55702e12df49a1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c88b8b03db60f5f035a987a1e2d97eecdc4167f3498a5e28c5a6c42db5c11f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bc7c0752eff618f7db52d75dd0e9d54223431f0db7d5f3f1885ff1a481bec6a"
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