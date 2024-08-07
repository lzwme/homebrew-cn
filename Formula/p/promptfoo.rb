class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.75.2.tgz"
  sha256 "11082724b2df42e674c7c2fac4cffe2e018a40f13a86dadc07ddde6e2c879663"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37b65003288f0ef564720eb7c119e0002f17ed33838942be172afd02bbef19c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62f424b0a585454f4a99c685d15a6b4a181d383549617f6f06ffa37a6a8cba7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b0943e15f8f124266949bbca090105515e563f6024a1a3df7f051f90353d07"
    sha256 cellar: :any_skip_relocation, sonoma:         "275fb20a24e0fcf894edf481f1c5ad569b461e300c34f63b8220dd288d9756fe"
    sha256 cellar: :any_skip_relocation, ventura:        "f315d824c2f583158483c2b9f693512069d9b743a85c90139177d7055d085fef"
    sha256 cellar: :any_skip_relocation, monterey:       "3d2e7f7d748d86168c86a41c87fea991bf09a2056ffbf92e2c43f45268c89c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed01838076da780b44bf1ff436df43dbcd851b2a34cf6164f48f9330806a5a08"
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