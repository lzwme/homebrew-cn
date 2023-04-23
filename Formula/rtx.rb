class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "d0576f7905e2ab6966bb78befdcc04de35318ccd1a9301cd9822040825fbddad"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "154d69d90616d7a33725aa1cb7122c82f8d45b6b52862e64caea325fea1b499f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31189d7913ab1c2df4ef604fff822f59ec4d596ad324cdd8f70da511b3c8a5a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ddf028f511f271635e062d81e7c164f1225bb5304c7414b612bda607fcd1a33"
    sha256 cellar: :any_skip_relocation, ventura:        "0228726fd2b477bff1038eccdc4a3e8f4ae2b51531437995e3f498d5215bd9e6"
    sha256 cellar: :any_skip_relocation, monterey:       "3a41246ffb8d93935cd5872428cb2bf348db2e7fcd54b2e55fe80b0e3bed347e"
    sha256 cellar: :any_skip_relocation, big_sur:        "00100403dfdf9d5b51f5606afb2faf2e94216b1215891af5cb485b1506005230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f2fa06712c9b6d6263d6d1f92e13148dbfd99374df9c86d40e77886023e3f9"
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