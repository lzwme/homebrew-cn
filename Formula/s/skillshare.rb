class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "3f3317f6c4d201983a8f180a8d78d575c3349e91766bc2ffbe63cb0c34e1e4b8"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5f8cc2624fc7a6e5dd2a519929519776f7597415b46c7f8dc95999503ff656f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f8cc2624fc7a6e5dd2a519929519776f7597415b46c7f8dc95999503ff656f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5f8cc2624fc7a6e5dd2a519929519776f7597415b46c7f8dc95999503ff656f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac2ad3dc383972755548bc4cdd32e9c2740f57ab6204ce9e252feb548efb1587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee210a55d9dcd304564c573fa7769eb1d7196ccdf779ae4738acd385c0c2f33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b4892abe4ba3f1ce7b53e2225e6de11217043c9913360e85e3135d87104b9a"
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