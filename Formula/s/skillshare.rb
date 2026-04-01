class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "9c07cba208eb3c447a7657d97d3edc92797271c9237498422167ece4eb2ddde5"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cdef2addd9a32fb24dbfa122f8012d3b8567fc57a91c1288e5cc3b1e0f1a7d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cdef2addd9a32fb24dbfa122f8012d3b8567fc57a91c1288e5cc3b1e0f1a7d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cdef2addd9a32fb24dbfa122f8012d3b8567fc57a91c1288e5cc3b1e0f1a7d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "28d424635ccc88dcbba085cbb93ccbaa622a6b86ed9655c815b77729b4bfeef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c9203b9cc3f4503e6b4bb92006fba68a64de2bb936c19043e98cedd19cd647b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967a9408cbd72deb9305be998533841b4c7cfcaac7e8dde729b53fdbd463dbd9"
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