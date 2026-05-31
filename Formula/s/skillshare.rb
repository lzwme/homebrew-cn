class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "15ad3e887b8305df150b2dbbcc6e464fa6f5c4b042ea0d94dda171f301fbb836"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b452155c67406108e60d241d2240ab6ce19153ac71e74d678e801d8816a06301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b452155c67406108e60d241d2240ab6ce19153ac71e74d678e801d8816a06301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b452155c67406108e60d241d2240ab6ce19153ac71e74d678e801d8816a06301"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcac35e520bc2cd882381d80d33bb4df804cd2cd508f70b68ea0fc065982941f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "858eac261d0c67ad96ab9e1146264219fe05f3e7fec8d91da8bc71482b82f385"
    sha256 cellar: :any,                 x86_64_linux:  "d473c9080e3f7f0968739231492817bffd420ce887ab8b086fca9acecba8e593"
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