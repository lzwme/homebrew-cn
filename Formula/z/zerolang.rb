class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://ghfast.top/https://github.com/vercel-labs/zero/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6bbaf60c7710916c215b0bdfe75165455410527b764891e8aa5ef4c3c2438a15"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "837d118b2392972740f5a586efd622597f063bfed10cd26b92150f894d14ce17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9986b0996553708211fa35555e444eac2693ee1f61daf31de1595b4285dd8358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9aaf1b85c57408e465e23ceac8f528a60cd5b7b4953c4155660570709c58a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bb0fe5b0ba1f00989b7a505b3dd084137cb45ab1d6dff5d9a2f525c66a7ee37"
    sha256 cellar: :any,                 arm64_linux:   "6fc72ed573d325de3c6c8b7df59c31b4565dc639ed1df5a2cb596aa23f33e6b7"
    sha256 cellar: :any,                 x86_64_linux:  "d137997eaa80b76786fe2a9baa0e0ba024e2382133820efd0479d163bac9394d"
  end

  def install
    system "make", "-C", "native/zero-c", "OUT=#{bin}/zero"
    rm bin/"zero.build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"hello.0").write <<~'ZERO'
      pub fn main(world: World) -> Void raises {
        check world.out.write("hello\n")
      }
    ZERO
    system bin/"zero", "check", testpath/"hello.0"
  end
end