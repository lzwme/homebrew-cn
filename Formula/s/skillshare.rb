class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.14.tar.gz"
  sha256 "d275807b184f456addbbdf4d5d928500238accc56885f7ca2f6748e1cd9f3f85"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5797f1b85d6da4b1fe6a4929a83daaf505fa18977d7e47e6ebf5dc752c948904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5797f1b85d6da4b1fe6a4929a83daaf505fa18977d7e47e6ebf5dc752c948904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5797f1b85d6da4b1fe6a4929a83daaf505fa18977d7e47e6ebf5dc752c948904"
    sha256 cellar: :any_skip_relocation, sonoma:        "27a0cccdb9ea7e866001ca3c19ef58aec1290b52bdf3b07f987e417a03ae4631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fda151df265095870e80f15bcaff305c8eda48975be0d31aa38ac680c3b8755"
    sha256 cellar: :any,                 x86_64_linux:  "c0107779004057b947cbb89cbcd01728bb5ef438d1ce1be0d854b2fe9f475980"
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