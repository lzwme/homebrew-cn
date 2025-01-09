class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.4.tgz"
  sha256 "066d55662943803d8dcfc345d25d56ec17ff1f9346e264c0702503bb656ca02a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeb7c61ee5a42427b1a9a56870c323580bd9d19a33e2f2804d30a0403e513264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53f9739cb7ec6fbeba2e82ce0eb6190ece04573b06de16f295a6c457542fb3f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f18361226403f4f71998d2c4c614e6dc97e7cf518bcfdec0b324caed33fec3f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "51457f12a4ea7cad0889660b56bc1e709d137a1705a03712419f0e1a872beb54"
    sha256 cellar: :any_skip_relocation, ventura:       "409e7136d3178a80c5d8addd032cfcf7558e1ff46a62ec9826c2345fabe950e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2fbab578dd1e737e64395f8c44a949da4ab6f4508c4d5e3bee8d55f96861ec8"
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