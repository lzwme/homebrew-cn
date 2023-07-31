class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.35.6.tar.gz"
  sha256 "7e9723146611592d1b5c4c8dfa33e027e09af4f7da714f6890ef7b09bb0c23f7"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c55a62d6632322d56cb466816cf705d556084c5f1f6111768f620fdc40b798e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c323673f9c919b6230b9c09c33e9045d4a88948ce3998cf96894a8091b016a58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df79d5f8824d096445877d5145fb9107d2b11bfc6c6774d4f453f7ce0b2a5480"
    sha256 cellar: :any_skip_relocation, ventura:        "44ddf7e143029cbab88256edb6d4c86871901107fc6ee6e12cf28a1001c666a6"
    sha256 cellar: :any_skip_relocation, monterey:       "44a2bf1a57b5cc405b42440a5811f3551929f448206878f4b303e19252888c54"
    sha256 cellar: :any_skip_relocation, big_sur:        "146e8198f1d01901cf3bae8a76d670cf4b1a902583d296efc966a4b9c4062943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ceeb3ae4c1f99c1b722342a0f82d10d0535c485f433baa0b08e27033d2afead"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

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