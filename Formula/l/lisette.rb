class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.3.1.tar.gz"
  sha256 "128ffc3bd90efa45fbc8f8c465cdf3acdefaad52eaeeca86569f8a7f6740d7aa"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0679b6247823d52835273c5ad93fcf85abaea22af24a57226c0a13920398af31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f52b36cb62cb58e5380bdf15d316682962261548065d43a5fa139a2ff5e991d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d9c32f05e9ec14a48b1fce758fc06277a0559f6c6de169d38861fb3b3324d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cd9726499b72fd9ae329a1b2c16e66355cd44e194179e2796b9b9525bf15f3a"
    sha256 cellar: :any,                 arm64_linux:   "ee6152f4bcd87bf3952b2dcbaa10d299ca1f31e17542951de8d130f1eeaf51bc"
    sha256 cellar: :any,                 x86_64_linux:  "5ec90d74fc3b1dc41c796c9d4268648764da4389566ab621c3948b2da07fd98a"
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