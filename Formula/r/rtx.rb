class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.9.tar.gz"
  sha256 "66e9dd49b3f16724e382dc5a85278d7b27b2ae4461d6240a6e801deae2fbd97d"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2082e9a8db9f9f61f3bd94f654d72dd0969dc8fdfeaf9e30b0a3851dee68d98f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52cd5ef23bab30ee992048a1c4f1d7246ae98399054bdf0371317173c3bb52e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dc3b8431b9caa285b71daf975b83717075dace61d763d876e8de95864dd3bbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5a6ce44e206327452b736f03c875030af364d8e3f6b0e79cbaad0a244b5a1be"
    sha256 cellar: :any_skip_relocation, ventura:        "59b7ca291cb3b42d3451449fd9cd860f5795747fadeeb9cb87563335815ef62f"
    sha256 cellar: :any_skip_relocation, monterey:       "32b3445a269b88570a16b802d630f4d3e55bc33a4db8d8898abae2402f89540d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9682a91536c9f44977c742280fbd8b901dcf3148fe379d9c25cfb89f8e27a276"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end