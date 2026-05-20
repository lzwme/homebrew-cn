class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.8.tar.gz"
  sha256 "52488c541175058bc1064683c60c8a7be2f02bd9a2d193c86128c8351fdf4c74"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffee73c150340fb5cba47ddbbc58ea00c1426a0c6e808bf93a3270e9f4cb08f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c02f641f7b053c083dcc422d43cc701c523ff8a50b5114fbd8fceaad587a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ff5487fe36838ab5259f5de339482f6383d124d8348ddd6120a8b9a2a5155d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c778daee01af580a266014a6147d56a28144ba908452343a4c970211b61503a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9bba5ab031badf600a6a8baa808d75a967aeed9d1ace93f8665253eeb1c6ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a436497d6c8fb81d33092b829c3a75be3216afeed1b4679b5275df7c79173e55"
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