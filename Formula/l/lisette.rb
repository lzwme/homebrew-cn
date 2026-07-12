class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.8.0.tar.gz"
  sha256 "f9c6f52877a3c92244ec20b8a5dbec5e8949d8462eb962aa0259caf96b35fc10"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d7b4fa15c80ed4adb6caf2d65aad06220641fd9d09aba397f42ffdf9cfaba0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa100348fffad705a19b9c67923d7a6c1d163dc24bffa727c55ab9cb34ef0727"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e0085da51121d3b313c425b09a58b11e3b842145788384207bf0f4fcc549672"
    sha256 cellar: :any_skip_relocation, sonoma:        "a650840fb61cf7a0e2c5164131d5b1873806ffb1450c64c3d7d800ef2439f712"
    sha256 cellar: :any,                 arm64_linux:   "6eadfbf365e8112137ff7c83ffb94921e4b084af6b58a73500ce43895899fdf6"
    sha256 cellar: :any,                 x86_64_linux:  "29d7ec1ca7ca728c7afd5ef1eb95284408aa87f18c3b1dff488c1539e50283b7"
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