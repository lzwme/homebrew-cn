class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.3.tar.gz"
  sha256 "28f7cb1f37f00500cbe3c590e68ba8f670c086e5dd1451e4eab9597804c80bfc"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9bcd690c9168ea54b1cc11280305f9023d2d4ce10ca8fffbc20e6d504fe1844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce39cec2dc68f488b299faaaaf4a4249e2b9dce33d7a0334f1c419ea053cb06c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09e0b5e7c4fdda13fde51db85afb5aca1649806b9cc2a7bd52e5471556e1bef6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e2721a49cb085f19baeae8dbffee2e88ee8485799ceb01c9a6cb4979289d0f3"
    sha256 cellar: :any_skip_relocation, ventura:        "cec08c5b8f8f9abb232407818625cd0444f0ff7bb29d7955f2d67356bdabda6d"
    sha256 cellar: :any_skip_relocation, monterey:       "df4ce72bf6437d16ed1991a23b8e7df8396f8eccda9fa51f9edde160243d7155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2a6d2a7190cab7b8fb65a79f0f988bc8932edee229172012ce8bb80fe09db1"
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