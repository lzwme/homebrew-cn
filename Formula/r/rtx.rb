class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.0.tar.gz"
  sha256 "5c7846fcdc883f409c66e8baad92fa1aa4873291077726155437d2d697f101f2"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f64244e5287c95be898a5870447c4f23e5a2c3aade71927f5b020971ee12f7a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f9dd82949104c2da76052794adfb239ac028aff760a7a39e29db8113c1c0f62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f38c42c386dbe9bb1fbd63e0d3d9df904cb27590063f720ccd81fe88258ea57"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cf77aacde1c38e0abd90ae7ccf14a1c64f52a5a5d7573d792a6a674d9115446"
    sha256 cellar: :any_skip_relocation, ventura:        "bbaab830f78811ff901727e61d07af2ac3041b30b0cf44d993ed5d0c19431dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "24bc3eb5da41acbf99e6d9be6fe3583ac14db8e13359c58d69744a08e6e1f46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97232242c610cae60ddeae1be75d1db1eab8ce329b6d607aa69c584062afbd88"
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