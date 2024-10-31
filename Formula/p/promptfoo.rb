class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.94.6.tgz"
  sha256 "a14ae79d1d56b5713fd5d762da6fa470b2980d863f08d31cb566f78fee90894e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb402a34d6f88ef38ba25880ddefab25f247beb1923c1b06000ee2e5c5160a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0da9c5b88ed55569d10e45b694ae5b1f334f8d874ddc01ada6cb7c7a904395df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0245cddd04cff59b1ca0d8418dd371b427a313aaf8de5fdca32d1ff25d979256"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0a75ff25eb5e7bb30d59ff545f50da8fa4eee7583d4d7fe2b0fc1d864a4ee20"
    sha256 cellar: :any_skip_relocation, ventura:       "5489ddb6c92ce1be5265293820e3c6749252f08e8a535c2f621c42f94ad0947d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a25089f6b24642491f146e47ba0362b2a77e75c307371d7e3a45fcbab897d824"
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