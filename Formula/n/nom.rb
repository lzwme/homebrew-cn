class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://ghfast.top/https://github.com/guyfedwards/nom/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "414f3e5285fce2e15879f1f33ffabc05c2e67fea633a64e16d8f344bd499b08c"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84a7ce32665d6ee23afb90b855b6eebfab0e3e4c6a43408c848f5d3469111c74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4558c3bf1e86d3f267e8576dd12013862b32d7fb0e6c64b9ad07394ff5487c12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c24760a056aaceb1bdf5e4297e03b21c0d2b8041ff1fdd36d7dbb02eb4dc7fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad3c123242b9792d961c22c82d97dcc66b90aeb42032f857eaa3732f158eeeec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c7755f941a64ed3abeb2139ae77d793b5ccf5e920bf5421140c2762090fd0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8df6784946f7a69a6a4e1f2d0e55fbf5718bcb6a0e259a97d80a36082feeaa7f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end