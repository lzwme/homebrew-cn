class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.4.2.tar.gz"
  sha256 "03768ea40efb83afc7ff6e2f3e42d0d3af3e19f61768ba47640dbd30e9eec7ee"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bdd7c036ecc42e19800aed601974e1470dee37e025a768c4fefe29d8a92eda3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "393a39fbb866347d6fc8ed58e2dd5037c715f23996b1f7aad1d8ec8793ac32d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "144fa605ef591fe6ea7329665f3cbf938064190c8207fea084b2dd30b7a66463"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c31a3fa0208705e3d5d7e4c5f2cff5d5712d9bf834ba9de65bb1e599ec0067a"
    sha256 cellar: :any,                 arm64_linux:   "8b3d846b4aae8936cc71d468fa2b227212d4c496e811aaca050af7bd4bd92227"
    sha256 cellar: :any,                 x86_64_linux:  "840de5becbf1c8ec21115bce55911711086fd4aaf3b096150ddf90036a0c6a41"
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