class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://ghfast.top/https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "97d1cd93fcbb654c88b48435c8ce02e07ac3b57e2ddf1d8d0549681a0695b051"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ead31a2770f9527b2a96481967f9b0fad98d9f3bcfa8e2032e50da544a8138c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad6ed42db5f41b625fec531c2edc15f4558a66c9e488bff5cedcdd5545940ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "947af0b6d5c3241a362ad4a2ee5c6c8c55cb80b260564ea3087d61b356ecf47e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed63f585ddf9869d5e7e38ec2d1aef4c4ae3b975f95719a214bca0c795c84ea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "349d119faecc11a9efbd1297298ff82abe45a06d5f3f80a2f0dc4fefbc26eb81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5addb4c2b863e1a78354b25437d26551a7e2ff9fcb5ab52ea3e80142ec4ebaf"
  end

  def install
    system "make", "-C", "native/zero-c", "OUT=#{bin}/zero"
    rm bin/"zero.build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"hello.0").write <<~'ZERO'
      pub fn main Void world World !
        check world.out.write "hello\n"
    ZERO
    system bin/"zero", "check", testpath/"hello.0"
  end
end