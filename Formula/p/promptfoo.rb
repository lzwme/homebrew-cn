class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.116.2.tgz"
  sha256 "2925a3e5d5afeb547a69ab3104d3a86cb668dbe28db79ac0bf537a5b81b1d1cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c236d1f7318d10f5fb5d1e2dcb1a9f37b9799c721b226f36d4ec7e75499bf671"
    sha256 cellar: :any,                 arm64_sonoma:  "4c4e5cc749077eddb9f5a5b9818f75c460a71cd78727707633b0ace8257049cd"
    sha256 cellar: :any,                 arm64_ventura: "46b320a1df7ffdb2fd6481c75672539212f67ff9bfa0d6ede8e53ece7206bdd8"
    sha256                               sonoma:        "d9011b50df0e411cb963508cff2cb94db203b561c907058778a7cb6d2af62b1a"
    sha256                               ventura:       "4f912476172b2c00b371632b5774abb7bc9b2523b49e51bc1f1da823a3e8c45d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c3fcebe1e70fad1bb8f1f1d8f8f45e06efb637c895873092c83a83409cd274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f219ff1ace1e9c017a23ed9a99d73e1803e15d42a56d4e9136bf8db6345c7851"
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