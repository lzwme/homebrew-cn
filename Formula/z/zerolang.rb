class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://ghfast.top/https://github.com/vercel-labs/zero/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "d2d6914255b2fd2dc0ef6fa85efa21dad87d8a1d64fddc5d20ebda6198a1ad96"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c306d6bad0e956fc7d405e3aef1a6c752c7645652119fc4dd7ac86325ded0a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce7ef764aad748f0ea54685ecba911477086bf570fc559c16d1398ee13da48e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f03b704464e4d0e66278c0af484b3f2585f68bdd1890123d2b9235f2053759fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ef91c3dca408884e997501fcddb54c4c2c1dc4586d68cd20ff3ae698d7351a"
    sha256 cellar: :any,                 arm64_linux:   "9ce75881d7df994d515ebf0ab650995aa0cdcf2f71458bc3095d7912d1670a73"
    sha256 cellar: :any,                 x86_64_linux:  "5a1c9e8e30c156d0a0407b4bf4be56d16f9d256cfe06c39d55594cb586c153f8"
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