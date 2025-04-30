class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.112.1.tgz"
  sha256 "97a12769ed1e285372c196af5c1794c26f55ea47ad60ac0ca890a89ba28d5c0e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de9497eee2f0576b7348677b48ff85557aa9c84ee0a5dd28f9aa3461b272eabc"
    sha256 cellar: :any,                 arm64_sonoma:  "535c51b54181730d3ee22a57aa8f9c3b9eedca18d3a24e8ac548329bb77a6cd0"
    sha256 cellar: :any,                 arm64_ventura: "22df9353a64a1bbb2ad8cb43ca569feb88c9fc88063be77a54fd313d71db2ed1"
    sha256                               sonoma:        "5c523accc32c3a9009e5ee918217abeee69ce58a78222bc1ea8a79d404ef7d5b"
    sha256                               ventura:       "b9f6f615aa1980a26e0eb31471740f99faba0056e4e22e46d0489d59a7d92c23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae9b999269e873b118d1e3cd551999f5d6305b5e53620ef31fbbb66c39834108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d6ab8008d10729a8a8c8bd26121eb91d0fdc9643c33e79e9cb320d01c2f3a7c"
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