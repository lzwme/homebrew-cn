class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://ghproxy.com/https://github.com/pressly/goose/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "de4d1579a28e6205282fd2eec849fb83a133b579435c2726343bdeb145f5f25e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "009037b0d73c00a52a99e0f32762627614bcefbf6c748db426cf69b6f34a06f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d540528f758bdc37f12aa4a7cd637e6a0ec43f4749aef8dd324ecd2ec166a74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f18e62b47c049598b285d9bd195a3b979f6c65b8d33480a9c61f7d49c1c1cda9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ceb744a1f3b005187c66f5142d2d7684d7407d65a42a4aa9759abf879be78d6a"
    sha256 cellar: :any_skip_relocation, ventura:        "f77c349170825280b79097f0184e49d018b5476ba6e661c31c14073e897ffd64"
    sha256 cellar: :any_skip_relocation, monterey:       "9254a1a390283b1e0cc301f6f2e0176771d0f03fa6d718f35a1f190f98750bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f1d6687a53693d73425285040c3d97f103e64e8cfa6b9fa682221a6bcc33fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end