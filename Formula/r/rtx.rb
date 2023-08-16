class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v2023.8.0.tar.gz"
  sha256 "e8bd55bbc463896c48bd8c5cb20d6bd18fd62998dcfce6231af91a680986695e"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c152246ed2ef4aa72da2155e14d5b577a518246c8b14a4c1ce0f1021991a976e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96e82fa8189ad026a4611e855b78d5856c6a5b4065775bd5143003e66dc711d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f59bd0459df332b210132f2b11c71d790d3000be411eb530b5a0feea4f6fc9a"
    sha256 cellar: :any_skip_relocation, ventura:        "405d451ecf2e7aa8720ff89983e4fd35f3b0778b256c191db9baac72fda32826"
    sha256 cellar: :any_skip_relocation, monterey:       "27585445672c058d1fd8948141ff88e1471e4cf7b49aa6ad657276fe63d48ccc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ff9f2884615666d129b335c516ff7e616638ce236cb99effb36aa0f6534c751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ffa86c5f9ad43b2c41b4bdc80fbf49211679d4fc63e92902bb5b26fe05b9b76"
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