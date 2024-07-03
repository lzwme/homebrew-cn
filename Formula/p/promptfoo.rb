require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.68.1.tgz"
  sha256 "6e255213f495a7e47e7f67fc5da97ef50e412cc21c9385de278a779a78c1b4a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e74bcda97b1c6b0bbe23cd459a00f36650046ba05d656ec381c9809d9935767"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a11b28301bfb43d482d6cd161f9fed690572f8eb48601e8cb81a60c617286648"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b34e88ec1e8e775f3a8006bb6ef4f979498a39838cd1d63a495b492bfc6dfe67"
    sha256 cellar: :any_skip_relocation, sonoma:         "282ad8bf2763725fdb9b0a3d4327819f9a683cb8ecd921c285e2abd4b57cacc8"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd07e8ed0c5a4fac24d874400e3881d06e3d5d014e8ded2e5b788c36b28820c"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9b12dfcdf0610db8782df62aa7de86545fa431ae6e923e410f1b5324ee53ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c459293faefda0557d40a6330c388564d902e1c00d2bb819bb9119d04fe86db"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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