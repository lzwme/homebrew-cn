class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.78.0.tgz"
  sha256 "f3d228c2977469515f8283eea346388c5ceef842d3777365bfb9b383cadcea42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3aff9bdd91c0c3e33a31901ef277aa50ecdbc0e5009113013a1a517046055d14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69741c380368b8599198f0b8c269bfecc17e69c50b326fab262369f90acdb40c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de8bd23a3c389484d5b5af6e347cbf4514ef2a0a2bf875891518a45d2f7d9928"
    sha256 cellar: :any_skip_relocation, sonoma:         "f12d76fd27f0304d6909872d5fe69f77b749acae59f48ea24612d7d11d2f1b50"
    sha256 cellar: :any_skip_relocation, ventura:        "b7f884283cf92221f91f40235525a2536403f6227d5cd738ef9523cc75235c53"
    sha256 cellar: :any_skip_relocation, monterey:       "2aa8d340f7110cde682240615b667404a2e2ea20dcd702100ec77fe6b56bc2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f37a4f4f6f3dffb190c23785f2b30aa9003a9c730350e1d1ce12f5bd26aac3dd"
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