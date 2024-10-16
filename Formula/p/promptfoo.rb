class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.93.1.tgz"
  sha256 "9ebc10297b43ffcbfb91acab20d86fabcbed752bdd638f98d72e77229518888e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1bf9f1a7e7aa0563c01a8666120f2c626b9ecfc9a498b80b9b9c2a035e5bf41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4012679c30f1026858e4f9551a1e7452a9822a0e3c0457cafa73bbb887e0330"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae381bc35ca96bb8ec7b130ae46dd3734750981ad912a0886f367f52c82d9d7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d2e2b52c6d6cb4958c9ce3e3338efbf1d90efff86150016b094b30f92287e33"
    sha256 cellar: :any_skip_relocation, ventura:       "aafd9e384a82a4b0ee91b17e1b6d329135ce3ad53833d8bfaca451fc25e40346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7818b808c655f0f0000d9641ee8feaa82adb821a12c3ccb5690c2f633bac42c"
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