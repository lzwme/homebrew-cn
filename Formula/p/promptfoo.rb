class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.89.4.tgz"
  sha256 "6bcece3fdb180804f679219de028519ac0cee692ef849ce7719a7ce3587edb56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32980ea02514168381989ea47a1861525e90f3ccf72d5bc744f38891743073a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e06130ecad45353d4b6848cb97d50b1021465e24e5c832fd11f0c0d7a9f62e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd3fdc8bfe80dded258877e9ddd25cfdb555076f03ec63f88713695c94094bac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e0d4c17f10e1fc758d455286fcca29c5a2cd5bc0c19213fe8a0f4e13201787c"
    sha256 cellar: :any_skip_relocation, ventura:       "9b9dcb74eed9609fde651aba961238bce0d042729015694636bc3d88cd794220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b1abcf36b984e2eb86fe9b2dc797bf498d0c62c05e95c41a87e23397a648d14"
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