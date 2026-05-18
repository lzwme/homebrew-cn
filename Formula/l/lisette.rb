class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.7.tar.gz"
  sha256 "e4de6c128e83cdb8cace15fa365d956e5ad34018eaa52347b0dfc1d28513dee5"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f5cc904b083f5e9fe7291c2356bff7fc590ce285c93f56a254b86c37d404c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73e1e3e93730440422393f2bc695fa8d09d72308c9b665f28527d58335833011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29241507fe2e22018a56580509d1b5e9963aefd1feae3d801c24d0586bbe5745"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d7932fee6534949eb686898174c281818fc077eafd84592e93f3d91522a719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0826de6f926aa5d6727fc41ed7eebd47563c2c9b9f0f02afa7973d92b15ed2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637fc75250f42c98b6ee854154dca4ff05690e81c6547f79ca56ee42b94ada9e"
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