class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "32eb63c9699b8249a81bcf27e68f05ea1cb6d7e65f6f5f225439c3da351b5e01"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2dc9953885cd30fec5eddc41b663a65c4d10476b31baec775ef1a03db4a5abde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2dc9953885cd30fec5eddc41b663a65c4d10476b31baec775ef1a03db4a5abde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2dc9953885cd30fec5eddc41b663a65c4d10476b31baec775ef1a03db4a5abde"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a9051a4fd1ab2fbe0668737a500cc6412b8c0bc5e8ad28b73f54bbb3014b617"
    sha256 cellar: :any,                 x86_64_linux:      "258db66b0d26e1ec3c87f2b3730826bf4df5d51f3059a69a0e87ab9f932045b3"
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