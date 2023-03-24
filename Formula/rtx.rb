class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "b16ae68b3cf9fd0bc9f197510794a76b253ea2670a6c7300cbf354109aeb8dd4"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6960468fd4f75ff0f60280f709c4b4b692431f44016aff6d32d3929e6b6accb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "179ca9293eba338275ec6d47f43b322e3c8f4690c1bfcea5a61721bda706e37c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9d0d227cda174d5fa36e9795bc8ea5f3c43227966874391f41f3d7775cd8966"
    sha256 cellar: :any_skip_relocation, ventura:        "ddb599bc2f1b12752ff4553c63611de25031f2e5c22aee939b2fd25f73e40ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "60ea61dd6c2f11884b0af364fbc8997349536d4b75a26246edaae87d6c8964aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ba0455a2eb6d6f07d73229c53c72304b4a2f09e5d678831f9eb0d7b2610c269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c94c345c690a63b5b30fb54994ccc3e29429beb22384cf9b52ab77f55fd2fde"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end