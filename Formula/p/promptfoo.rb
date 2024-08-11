class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.76.0.tgz"
  sha256 "97a4776033d33bf2b826edda830ce99dad49858c983a5d928c4f8c2432245763"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "978b41239495423732be7ab51feadea635bc1e519ef3137a23a95d942a2b3ae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c95df3025d07e31dd7e9d1a5544a2424d83e69008671fad63a569fa7a36427d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ec4454ce272d7a5621b053768a5e33e3a89b348d81fd04aea4d27af10c74cea"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f4beaf7b3260727a8276a71db2556e2d6410b2af95090b72e0980d92a98536a"
    sha256 cellar: :any_skip_relocation, ventura:        "38dc8adb152281e42fe2f635a42093ca5c4607e10b8fea857a5d2b3961db4385"
    sha256 cellar: :any_skip_relocation, monterey:       "ffbfa954fe79de73f535a164dc18f3960c0a8439f8b987f0f0ba9bd788159767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50712865149654c43c79a734be6420640bb0b3fcb8bdf026d5dd7a1ed2ba2b14"
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