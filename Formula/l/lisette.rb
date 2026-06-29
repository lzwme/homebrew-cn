class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.6.0.tar.gz"
  sha256 "56670fb9c0f52923cf0eb965d70c35fc0dad42fb6115f25d4637c3de81daf502"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c205ea1d69f4d2b14ff29000a92762b3e4ae4b9c3ecf38afd8ebe1bca4b5606a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32e7648097e3ab4dfd3c53e6d82a1ff08100408f9ec0979f29637eacf5c33891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23af007701b9a9f36d554b0cfe9da0443d5bbe147d5e66b1b6177ee0a13e54e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1770c38bf73f41eeb0eefbeab82acf982320aa902eaacc52d8f20bf4a6593042"
    sha256 cellar: :any,                 arm64_linux:   "5d7f82665fec4b639637c384619839eceba816d79885b664aa22e4da543db286"
    sha256 cellar: :any,                 x86_64_linux:  "7c16ebd47613db4b3336bfb5b1b2079cde098ee603e151b11b6e6da523fc397a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lis version")

    (testpath/"hello.lis").write <<~LIS
      import "go:fmt"

      fn main() {
        fmt.Println("hello")
      }
    LIS
    system bin/"lis", "check", testpath/"hello.lis"
  end
end