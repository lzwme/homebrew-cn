class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.3.3.tar.gz"
  sha256 "d7e7d8aa7ca4d1de92f037e41c2d97b0628dd1891f9368ec0efeceea222c6d32"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8ea05ceff9243acba69dc33bba1ff3f8d088c255e8bd492b411ef221eccaa7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "985da173a59d46486c665a5420b4aa2bb74a9ba5b5c1c7d905c2ca8aebb763c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8faa01eda2181c3ab1594240959ac26c644f48c091cc83e7ed479863eb6b230"
    sha256 cellar: :any_skip_relocation, sonoma:        "8415d7cbee2e3ecb6c36bb036b8f240197d7ab7b2baf3ac75da8e2819f1dfc24"
    sha256 cellar: :any,                 arm64_linux:   "fd3a06991f70ff678aa1ca648e944459fac7110fe514b32db9f394a2b2114ed1"
    sha256 cellar: :any,                 x86_64_linux:  "c0eb8e1a1918e0f8317e8c7fdc65e2954856e0a98373e3c91dad92aac4a885c5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete", shells: [:bash, :zsh, :fish])
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