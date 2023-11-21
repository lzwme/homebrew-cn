class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.13.2.tar.gz"
  sha256 "9665d93d19053c5222b0daa83afc52d0851246352b09a853feba80078b212871"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83f222f0b1b18924cab4dc314d58d64bbcb2bd31714da79cdba138267bcb485f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f319e96d014a4dd36ddf478db546603e26305618f382e01b97a2546a0e53451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f826c3b5d90df8cb46bfc297ece111393d92cb090e7ad7532d4740cbee17f27d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cd48b6e84fcbc5046f929b431a5fde1fee47b0e8fd763f0a80f681a2588483a"
    sha256 cellar: :any_skip_relocation, ventura:        "9be7f5e2c54d7b5b6f7860a0dd29678c29f426c74dfbb0890f3b7584df2675c4"
    sha256 cellar: :any_skip_relocation, monterey:       "e9f6e25c8e2f0c668ee463249e85934c28c960d209a9322e329e9150567b65f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6955295154bb1011867ac382159652a7c2ffb522dda6fc428d18f44f84f8995f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end