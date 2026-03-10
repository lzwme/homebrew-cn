class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.14.tar.gz"
  sha256 "ecd37db3e3b71e226204adf72c04e6d7bf366bd5cdda6623eee3051f779495ac"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f17bb9dc95e5504e063220e355b6a262490fd81d10a0fc47d494c221ef9eeff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f17bb9dc95e5504e063220e355b6a262490fd81d10a0fc47d494c221ef9eeff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f17bb9dc95e5504e063220e355b6a262490fd81d10a0fc47d494c221ef9eeff"
    sha256 cellar: :any_skip_relocation, sonoma:        "699e12aa03e88785b5c200f5559983ef50d3026409e140ce90214799d0617b5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1311d40167e6433520a9b8f2f4c50bb5a46259ac4f8e4e107c16d992795482a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002f65d5befe8b733a395dfe7651ec55bd8391b4fec0a06249baa25c82987a82"
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