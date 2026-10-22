class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "198c5a536cb25f95a87f8076c01c05fef247548a9f93e918dbd005395b118475"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "efb8a8e9105a27f795c77260cd423188b3ff196029f374e47b70a34530a77763"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efb8a8e9105a27f795c77260cd423188b3ff196029f374e47b70a34530a77763"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efb8a8e9105a27f795c77260cd423188b3ff196029f374e47b70a34530a77763"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4960b565cfa236371051c2e693e9d18d10a580079fb6a4d0f83cdb3b65ae32e8"
    sha256 cellar: :any,                 x86_64_linux:      "615beb7c8ef09bbbc83dd6f583e08941ad5ec100454139a99b88b1d5e1c99fc1"
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