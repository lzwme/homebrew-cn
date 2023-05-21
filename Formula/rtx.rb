class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "386ea54f2c2cf7dfa647b6ab0ad5dc51889b4602893c4c64beb20f38d943c507"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68137ad35b89fbb8972b745ce7f032752b5d207925237f8d232a3bb836eff4d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66df770f1af0c1693a0fe1b5ce01d42220cc2cc6d277cb8c73edd22694f27b08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b83f8fee5d666e7469fd9734bc7c9411ed72251daf71805842d23e4f1d7f2f2"
    sha256 cellar: :any_skip_relocation, ventura:        "346f78e71043d6e6bbc1f3c569a034ca065832036858422e0822c07bac4f3877"
    sha256 cellar: :any_skip_relocation, monterey:       "f26ef8981c24929543a4d9327e5a3c839b137959be100e1768a8039542e854f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "28ddc54d71d60f1c8660785d8c41b3c5402038176a029ea2a8c1e551ab0e5a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1e7cab0d64173b5db4b46839e17b320af43c576184e0be740b5d607d6b0e5d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end