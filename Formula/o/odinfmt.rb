class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://ghfast.top/https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-08.tar.gz"
  sha256 "e8d368f35b6833efa7e840753881d01f76607f3c0872c614e536f2b7e939f800"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f26b6a496b8213bd10aad2d2d630ad8d3dd202bd62f36bf766b3b1419dfc9c5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16240d03be08c79ff463e78278f04e72a7b73f89b0c9990dbbc76a42bbffdd41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "487253cf55edf35c4b603118dc4090f416c207d55f17f1233ab7e0606dda5111"
    sha256 cellar: :any,                 arm64_linux:   "9210172c28d1f25625325be06afa3e18c2b23a1c02ebcbb375f6b8ca68bcb2c2"
    sha256 cellar: :any,                 x86_64_linux:  "655f9706f47e3d2a6f919d95cc4cbb5c60e292713e9d2e742146de4d9d9177c7"
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