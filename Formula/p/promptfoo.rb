class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.18.tgz"
  sha256 "42e891489f60ee759adbb0c4c89dc7885fd12fb41b5cdf38d9686ae0b6fe1074"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46aa22bb0aa934c48c13abc804eda86735c36ca03e004b75f6aaf4e4d0391c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a88f80a19ae1126bf240fb5d98dcb064b6a63b0a27be30a14b2a0e33c0cf4eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3246319f2889f58d6eb635afefc2d1b18835bcf18c01392c14ee57dc3e5ab0f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "499cff27365e0ad672381177731e689040f42b5c732f57b3caaa6b24a5a5df36"
    sha256 cellar: :any_skip_relocation, ventura:       "0e85b2a124311e120fec165a66389bba6ea1dad243b7940fc6524ec4544c4e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3506986eb816b881a93b89daa8d2b66eafdbf4498341aeeac7eab5d4e85ea10"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end