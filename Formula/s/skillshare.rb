class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.15.tar.gz"
  sha256 "5af6ad4a31cdf9a4637c8984cd7fc7e405637ae3c10edda579d8f522dcd99daa"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6abea9273227eafcef589de55968d88b4ebf6eb77cb2b0d1f3d86f79d3f3c69e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6abea9273227eafcef589de55968d88b4ebf6eb77cb2b0d1f3d86f79d3f3c69e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6abea9273227eafcef589de55968d88b4ebf6eb77cb2b0d1f3d86f79d3f3c69e"
    sha256 cellar: :any_skip_relocation, sonoma:        "088e962e87ee506404b92ddc44de5de6d1acd94885425802753e622c0f6757af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbeed057714720be0c31a38e7af6e0905001a7f2b36e72737381858f938cc8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d35926075841103c179c0dd29831d7f6d5a89fc6fd44883e40d52b887814e95"
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