class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://ghfast.top/https://github.com/yarlson/lnk/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "fda0af2b14540d624339d41a51c21b72ba0a946e05ec1223f51376d595254145"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04cc6c97a1918c631975cf204c070659c32c19d58c30875791119e3db14333aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04cc6c97a1918c631975cf204c070659c32c19d58c30875791119e3db14333aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04cc6c97a1918c631975cf204c070659c32c19d58c30875791119e3db14333aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1511ec4a9a4264136e893b4e4628d2e279d19a767d9e9858695c2d09aa99f4a"
    sha256 cellar: :any_skip_relocation, ventura:       "f1511ec4a9a4264136e893b4e4628d2e279d19a767d9e9858695c2d09aa99f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dabc9a20a314ac42aa520d4dd985568c519da9c5c74fe71227fb9b788490085f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end