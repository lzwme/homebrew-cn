class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.34.2.tar.gz"
  sha256 "0bc3397a73ddcc24213f11a68b02701ed1c3602fa2c97f211484c3266b808584"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65d18aaaac710e72c1cd048cf69d449f56ad0d92e9d217321c3f8aa2bb386216"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf0a2a0742ade759d188a0df016206bdbd770d9c5a581f82116447ba2cf7a044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b10e0bd4bd8caba90674de63c5789428c3f1a054aec4ece5f587eeea62c4a366"
    sha256 cellar: :any_skip_relocation, ventura:        "8c816ee6f1bb709d95b36c9236c55d595b0b0bdeed6849c65f190d8436af991d"
    sha256 cellar: :any_skip_relocation, monterey:       "cc5d152e65edc5c7ce9f6f1144dd3a9036635f928a07ca508623f29034f85baf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae5ddaa2b17331b04fcb3f7fc014bee483bc8bbe7fc8be99e674b6951385b2e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf8c71f90ff2c401235c26b0b617a9bd71263997cc22f82956a719dccfd3c163"
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