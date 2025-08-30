class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.1.tgz"
  sha256 "f6157386b5976e835f1cc0b10d100ecaba8cad5329d67d1e676cb8e0406b284f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ff6d077827a7d9b6d5f6c83b288ddd8bb3951629cf60fe4e8d6bbcd24a453e9"
    sha256 cellar: :any,                 arm64_sonoma:  "683e93abadb80f53ec4926505a4b7f1f0ff6cf5ca38edd59ee5fd1af58858e91"
    sha256 cellar: :any,                 arm64_ventura: "a8e342d18ecfdbb20021071a14c609d1a2b0138628dfbbad60e68285bcf4fd09"
    sha256 cellar: :any,                 sonoma:        "8697b4603fd38ecb74788e34ca77e31e42069b040971c4f665d955bb9f961965"
    sha256 cellar: :any,                 ventura:       "d62d81f7f88ba433e7b3200a363cb121e18e3bd99778d698ef8f99584f699b45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58b7e0e817d8a3ded8d863e6c0575be2956c88dd917e3da9780c6e508c625167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12249ba02bb91373abadd7459901b549bbe1cbfbda544d76af4867a1de1bf15"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end