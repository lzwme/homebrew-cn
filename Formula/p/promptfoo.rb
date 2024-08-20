class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.78.3.tgz"
  sha256 "2c47cac6d1813da46c27cf59d48c812cfd02f24c7b9d8c26b5581733352ddc38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7b3ceb5590de2e8fc20170fb7b8ead124b2d457f5f2db252c0ef0e3ffcaa749"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4745ca28afc16e136ad6ca5f3e90f172dba8e489998918b526394f0a704be7ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abdec5f2b4704e2c07ab0243576b9ad9975d28b7500e576eb5b62326b0a8d164"
    sha256 cellar: :any_skip_relocation, sonoma:         "d26306fa6556b3aa13666bd012695a6414958bc539ff7d15b4dfcc5fba43d834"
    sha256 cellar: :any_skip_relocation, ventura:        "7bf00aae53f7ce46db73bd08e388b9dd73038b737f3a593d9ddee71b3d5d7546"
    sha256 cellar: :any_skip_relocation, monterey:       "d170fd6bcb63843d5efeec995a4380044fbe5e25a12e4aeca50acc19721fcef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19a3fee9e8ebcc0d8104818e4244417686b6e8a23d133f923a968daec260ae84"
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