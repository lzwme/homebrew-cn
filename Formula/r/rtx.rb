class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v2023.8.6.tar.gz"
  sha256 "a9dedb30b4f9b89178c07587f8db218bd4d77abe0090173a1859cab50e9a147c"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1646a4d389891b8c149e9f2b6ea121e8ce21e9f4c308664ba5671b03da8aa97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a666ff63be35cf5857a3b56dc322fbbbe00728901c5262cf534fab9c8639b404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f92b30aded00c5fce3a640910f5f6ead508dea6120afa5ee96946ed19e50eb"
    sha256 cellar: :any_skip_relocation, ventura:        "9982e52bae6d99cb191ca51dec3e2b1cfe03bb515d812d704d517f9e03d8655d"
    sha256 cellar: :any_skip_relocation, monterey:       "e70bf54d5c9526dd548dee3ae8b352c0ed6f17fec8d8b5b14b319651758ae770"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c608bce37cf15d06c2049989bd16d45d653058502842a9367a43fab537f6bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a8f73f3352c9cd1f0115e0e5a4cf1ec4261df166e43fd3afbd08ab0f97cdbe"
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