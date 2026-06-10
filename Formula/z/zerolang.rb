class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://ghfast.top/https://github.com/vercel-labs/zero/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "235f04df04cf6b85eeac3779d40ca5fbbc8d68e6e34a8cfee8d6eea6760e9320"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6d2d5f995b6bb318a53e6d23aac277b982b7e00114df671ae0aa7672a5e783a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52841475c560559e4b286c62b6bfb6c0c40847faceec9b455a98397b9b731c65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a4c06e151b36d717532d20597c94f909c3ea5c7d6d0c0e0180383aa7259627"
    sha256 cellar: :any_skip_relocation, sonoma:        "e29383ebb274e0b68303565ede68acd89bd970d8e4077ee6e975105c7bd65723"
    sha256 cellar: :any,                 arm64_linux:   "b32c10b5f12a7548eda710a6c8aacd7e6de0dff2ac2c85f6bc5c69c63e3dc6d4"
    sha256 cellar: :any,                 x86_64_linux:  "cdfca533c24eef64eb87ef7437d41d60556f055c488cdfe23be834465c565457"
  end

  def install
    system "make", "-C", "native/zero-c", "OUT=#{bin}/zero"
    rm bin/"zero.build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"src/main.0").write <<~ZERO
      pub fn main(world: World) -> Void raises {
        check world.out.write("hello")
      }
    ZERO
    system bin/"zero", "init"
    system bin/"zero", "import"
    system bin/"zero", "check"
    assert_match "hello", shell_output("#{bin}/zero run")
  end
end