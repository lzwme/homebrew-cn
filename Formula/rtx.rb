class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.35.8.tar.gz"
  sha256 "fa04aacad2ed9d80df984d9c79c04185dd3ea26b6877f17c785afeee0c6d3ab7"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebfb71c219083e9bb71f5b01fc195b773ed8b4db1087858238d10dce457d9f6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1efee26bacc8c1d0fe83d3907357000cd136b3e1ea4ed667c3debdec9e386218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb585f8531e99921acbafc86f5f699508499ed449930c7537d8d14538ef4b935"
    sha256 cellar: :any_skip_relocation, ventura:        "0e56824e43111288cbb26d7fbae1e897d783cfd6f9c3e743423d4ed782330fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "6977b7c95176dc83ec28c22d7b1c922fba26d7b129c235d7de1b83a8994b3b57"
    sha256 cellar: :any_skip_relocation, big_sur:        "c900ced4df8b65e13259a785523e2a37d6599a2c17ecf4f1eeb1a73555d2cc2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "187869b87b449b8f2432a57f2682ddd227478fbfb59c5bc7cc92e32a024a615f"
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