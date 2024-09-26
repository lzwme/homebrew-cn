class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.90.0.tgz"
  sha256 "8c0c2a3ef1dd679cc772a06ce3f11727bc73688ae04eac51c87d8a2b4dd7aac5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0715d432af676a132503b6782bfcf15226b76739ae2dcda16343ad4b27cd7d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715c5eb35ad609bd96208b3b3002d111c37e84babfafea440d67fcefea6a71da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97502261553fc814a5d2e0d3e583ffc5c06847b1a0353d0d589a3f53d3b6a104"
    sha256 cellar: :any_skip_relocation, sonoma:        "db748bc3101b46ec7fc703b1483875b8b81c6a6d179f56a5f886cd95469a9531"
    sha256 cellar: :any_skip_relocation, ventura:       "253cb3f643bf36045aecd53173daf5ee10bfa91c80e7437d130605a0a20e856c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "168eaab2a7f5db526c19f1ad0e11682863d710bcab0be95bf133d47793795643"
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