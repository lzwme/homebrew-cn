class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.2.14.tar.gz"
  sha256 "ce320d00c9c689155a8205a510118273eab9d6cff345a5f9f0dd74feffcea8d3"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c94808e379b34cc25ee3beb0b9a983431252284b0ba596316639d466bbfd87ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc25e7d4fb331cc112cb666285f7da9172f8ec2b7427c451009ea27611148c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bf73a831c679fdfe1be63552d4a38a2280cfe099dcf3358205b8004fdc6772e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dfa381105b9ae1d3c174494d2bff6f7a451444536f99e859be21cb0244475c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f43fb002851ae1c73230bd7b3758c021c185a8883b8ad17271df9ca398d179b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32685409af40661b6291cf61a7474179c75a91f806861d9f7471a7d3c8fc3db8"
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