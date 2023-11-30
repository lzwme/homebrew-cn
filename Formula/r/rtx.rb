class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.9.tar.gz"
  sha256 "169de6f0685fb7236d177cb53231988143c9e0a11ba5cf348f6c1d0cfda493c4"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3da4d25eea1196328ed0266ec8d5e28db94f8d797b60b147e4ef48d1df512ea5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d979b4895e4a3b726baf21692eca0268b5c47d053fa0f7132f0a02f8e0d2f356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "303ed5f7013941298d59700258532638ac02832ba7a97a08b7de52017cc11500"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d0f04d9e402c1b90d52134ea5ed69566002027052dbbfd36640f33c9b8913af"
    sha256 cellar: :any_skip_relocation, ventura:        "0e3b71592ba8699ee7b9334b16d9f19304df813ad566d9314c31974268c16537"
    sha256 cellar: :any_skip_relocation, monterey:       "6fe56d97fa6163eb6e7a471ede6f0a5689040f5e71a1b50f0dc8364f131a00e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a5670b9223b57ce0fc049861a9858ffa197fc8c12208ecffaf9223a14ca1ad7"
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