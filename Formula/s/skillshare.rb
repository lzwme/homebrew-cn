class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "e382bfb69008ea7cd25d07e68d51aae2851c6a17130a3d9cb1a11515c1ed1924"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2412b086582e451ba5ee21892255ecb60ad3b5285a7f249a0db95afac4ab4aff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2412b086582e451ba5ee21892255ecb60ad3b5285a7f249a0db95afac4ab4aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2412b086582e451ba5ee21892255ecb60ad3b5285a7f249a0db95afac4ab4aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "d475e03debcb0f61eac7b3fe15733138c181e4d7f8c214c201a5fe33ae97abe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c01b87cd0ee696a5ed58d3b78077f70826e0233a8251957b595c644603688719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42cd9075e11280497074ee8979ac79e5ec23bca17f6359c5126dd3264fb74c1a"
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