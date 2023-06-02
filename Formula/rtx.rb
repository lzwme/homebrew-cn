class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.30.6.tar.gz"
  sha256 "5f1691f5a1832058bbb12d8535d259a99daf73671b92e272ac1ec69bda6df295"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "249273730db3f34fc87f9eec9ea31298066ee91974398026b643e379e4fdbe90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "038f73dfed462205827c4c277667d9a50572f16f311f5d5543607a97fd5509cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7241eb5f4340ef1c0fde42a33f4d3be8ba47049cba23c8fecfca402061ae667a"
    sha256 cellar: :any_skip_relocation, ventura:        "463b46919136110feff3dd1ff3e301186092087a897ad389a9d41fbdad78ce9c"
    sha256 cellar: :any_skip_relocation, monterey:       "ab43988c13fc867906d99a7939c3e5dba44900571b69870c86498b24f19e3b22"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8abb6bbe26ce70c8b8c52c978075595b4a83d4fbb24aa1662bc224e2a851821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db2752a9db053f3f9b8bffc9db261a03f79a1337b4f768f24f80331b948361b"
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