class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "a01a25650a21120c9f873fdc128ffb8583dd970420559c6cc0fc4e9c63d2924a"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6495fcf6c6b1cee617e5037dfaf3cfb0a3ea9dc70ddab91879f2ac3d1dfc956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6495fcf6c6b1cee617e5037dfaf3cfb0a3ea9dc70ddab91879f2ac3d1dfc956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6495fcf6c6b1cee617e5037dfaf3cfb0a3ea9dc70ddab91879f2ac3d1dfc956"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e8e82ea0ec21061458cca9c4422671a8563a887de022b2e8cf1e6e594f6ca92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21a463ed82121e3223cfa4984bc86ae2d9ed3a778bf4dae86f9b894c4c882564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66470af8f7870a852a61c09532354d2189ee30ab20cb0f4463f2c8d99f258ab8"
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