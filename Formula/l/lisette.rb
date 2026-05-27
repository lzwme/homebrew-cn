class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.13.tar.gz"
  sha256 "7b6a67f9533f45243db3ea6b753d54c8e34ad7e84da0b8ef8ba8c8f5c2090f1d"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ad28adb0da1fa9ce0ef22353740072694c64d6b1a7f4e14275f0e1f9f7ac8e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "366ab51c3ec696928108fa6940caf60b674bcc64c4d1fddf3dbbe43d6c209754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a37c9c3f45a65ab59010bedccd2b7f3fe3e7eff47b185860e68bf2bfa92392e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0efa40254acc0942160eea49968df284305bd0f3a105c55aec3ea173b06c9231"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24589cb867af83c1bae6284cd1ac624dbe30a7abcaa1fdfe90286d487c149929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60e37c174b7e8aff554632a42a610c037f7faa75b6d76f91315a97fe04590c9f"
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