class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "6191ca8c4388e130497194408e8c5968184560d3f61b79de36bad535f0843801"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1b49e755b3c631271db7e4e93be3d8e28d898bd38b1bc2266987b0240592b2d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1b49e755b3c631271db7e4e93be3d8e28d898bd38b1bc2266987b0240592b2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1b49e755b3c631271db7e4e93be3d8e28d898bd38b1bc2266987b0240592b2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d66c336d032ac0930a94285ebbb4ea583e3c5a659bcf89f0ca182ff04c170a1a"
    sha256 cellar: :any,                 x86_64_linux:      "ebf8ec134ed41821b9ff2bd4e36ab5c0897eda6708ebc7779e13aae85ad79c48"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end