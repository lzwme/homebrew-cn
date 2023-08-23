class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v2023.8.3.tar.gz"
  sha256 "3b6f1853631d840322c6728fb75fbe2d7592f729c536278d8422798de6609941"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63144875b5e03f90b12b7c4d52ff5a8fe3b0f04ff2bbdbd92673000949f685a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b5b9ffe5716a888a0056b681d21617d4814addee8a5c33d5bfdd9200bd3ebe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71596778e55acdb3046022732d89b29599121365c4f84c3775bfad7e3e051966"
    sha256 cellar: :any_skip_relocation, ventura:        "912face869c46242c559c6d7e9bbd88b3419a32261de760a148f2d1695753450"
    sha256 cellar: :any_skip_relocation, monterey:       "2e2069d4c5fc0c11f1b67735ecefba80ffd0817ff20ff406004a7dbb72dd3017"
    sha256 cellar: :any_skip_relocation, big_sur:        "54f2907ed65a5c519bdf125a4aac369fa9c512ce710303191a636f7519998651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "452ccdf4c7aa219dfcd93ecba6b7fd1e9581e0c9c7afda236f68650b01497dbb"
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