class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://ghproxy.com/https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.15.0.tar.gz"
  sha256 "31e7a69eeaf66bc3767e4a94f5f792c324a9a0f04b45e8e7df6aefddc6c41bc1"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c8c8bab0a70fc926016470716be0bc6dde5a81aabe04e86a95c332ac0e5f738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627f39c71151610561a8846bacb31daf78caca66e2e617369d5ff97121b5e0b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d222e556df405bc2cd0568b9cd17b1186578d477643ffe9e3d91913cb41e9c31"
    sha256 cellar: :any_skip_relocation, sonoma:         "6297202c04c56381c0fbc99ff2fbe8d50895afb3f5fcd61a23e7181ed7a125d9"
    sha256 cellar: :any_skip_relocation, ventura:        "9b1130a4286892810873c4991c9cf1f34369a9b1aea178b0f15defd24d5fa172"
    sha256 cellar: :any_skip_relocation, monterey:       "df907cd4e67c6264dd8f8a0512090c702486aff70474310f6820e03cba02f51b"
    sha256                               x86_64_linux:   "11604d6c0e397aabae12084e56c8512750fb678066198c64d33094b7bed77c0c"
  end

  depends_on xcode: ["12.5", :build]
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    EOS
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end