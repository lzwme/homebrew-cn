class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.80.3.tgz"
  sha256 "2507614212d94ff1f8633ae2c1c25f890c46a7b9282c666dcf7770620e9d13bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c437dbac7a43b90a673df66bd35f32fb08d345a40b773f09424826894a9ae1d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3794ec1d091f7f9793827c9387d7bc7732c35820a2b8971cb51ca7ee84228c87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9abaf7f2bbbc614ba5feb3473e296b4c61987ad2364c116bf36982a926abdfc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b6067f57652536b8db24953afd1b134d82f274512d1d4bc313cd3e0de9bbfcf"
    sha256 cellar: :any_skip_relocation, ventura:        "5d006e91a7f7f728a9469aa57c755962ec8848a298f923c4910522cb68d830d9"
    sha256 cellar: :any_skip_relocation, monterey:       "e83cc4ee10e8dbb9f915b01ffc3675d5dd6075401276042d5e4d2ccdf79d3bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27b1c3d2caff8f3ac3815e9137c2342d8faed4cc07787e13625e27ad3faa3bb3"
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