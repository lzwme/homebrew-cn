class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "ec8e51ce9b24d098fbb371a119bdd0d9dca86ed8cbab33d129e75b7e10edd195"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b8be24ad85108cfbf0c9729f729aeca4096e59de1968d4438b9e5beb1335ee9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9e3424995cf1f397fc6d8e423e21d3df0c438750de0cb0902676cccea32f16e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da6ce93b74552b4119f8e6df09ddb50934e27e9e9513256a056f371575eca87f"
    sha256 cellar: :any_skip_relocation, ventura:        "cb0ca2e9cf203c32a0a9b9c03e759d3a6bd2e39f6daa3aa874e2024bedcb6207"
    sha256 cellar: :any_skip_relocation, monterey:       "c37d402d65d6e849bdf95e178298a9a7fd472fca4b046d76599b61d479e0dceb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e31a39b33aab62befb4d3473ebc88841679802b71f47c433823fa28b3e64e4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "750ed2029b666edd4e484bdf68abee933c95b1a61a201974407ea6c63580a604"
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