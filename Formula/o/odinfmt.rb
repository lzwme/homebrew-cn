class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://ghfast.top/https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-03.tar.gz"
  version "dev-2026-03"
  sha256 "7c0d9e0312d5dc0d49e1696b98217932838e1b132feb2a68950e6fa7d6d4a2ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f0dcfc01f828b69a0b92b60f4018d5a0bc432837c6ca0a90c50f8d5836d2e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1370ae5ee8bce4f165aea04aa936c5fbf024cc12f7306daa5bb2ea5c35f12cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8a7dc42616c8213a2a496dd0e8f116e10e7e2b4da0a9b2865e82897be947fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7975bdd23a557b07a79ecec72a05b274873e27178b8746253926435914819d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4a590cee08b1e3f18e05580d438994006988cf60d8f21b71b319c2df9d0870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d550247213ce28bc20e78227807dea73ffe2e4b9abe002df43ba80d7a9c012d"
  end

  depends_on "odin" => :build

  def install
    args = %w[
      -out:odinfmt
      -collection:src=src
      -o:speed
      -file
    ]
    system "odin", "build", "tools/odinfmt/main.odin", *args

    bin.install "odinfmt"
  end

  test do
    input = <<~ODIN
        package main

        import "core:fmt"

      main :: proc() {
      fmt.println("Hellope!")
      }
    ODIN

    expected = <<~ODIN
      package main

      import "core:fmt"

      main :: proc() {
      \tfmt.println("Hellope!")
      }

    ODIN

    (testpath/"hello.odin").write(input)
    output = shell_output("#{bin}/odinfmt hello.odin")
    assert_equal expected, output
  end
end