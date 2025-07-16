class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "8a630b1dc8f6e8335adc1d844f30f695f6c558cb9b1ddf6eecbbae7c4ab638db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5fd1dfbcec4026d89dd38bfd3a3c65b7b13270517c7c65031468fc692b6a05d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4ca1690cb78a08ed951992ff0ba86d313a79bcb9ffc2ca82472958af80b25dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c71bc0a34a232caf166168031d6f186937a8bbcd0bd2794aefa591637b24adc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d2980c59905d39898fb0cdebd38c5b2b1e14a86ca3398145964164456a461dc"
    sha256 cellar: :any_skip_relocation, ventura:       "cc654975e4a4a50310948440a98a9bea8df94ede443c1f5bad583a31c87ffacf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb184947002f6ae0df46c5713161d2176eeeaf3d9edfa54271bedc8656376aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "928b96d0a0f7405a98875dbab1652e3525c5ed22676f9643a88d05c08450b569"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end