require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.3.tgz"
  sha256 "db639a098dd25ae3290d46da10c62e7ebfb728406796513a59f3a79bafe0a567"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6b5a52246ec29571913d8ef6ccad2645ba417b98c1df562a7145f025fc25b0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d96b6f19b3abcb90a431420d6f49e6fbf4711008f318744a4e5c4ec72865d77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47aec005eb423bbea1e9050ea39ff2e94f48ea09003996d7e66f6aa6c1607f4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd8106c43498364ceeec7b6b1e7eb05597d68d5fda4c70940539a0dbcdaba59c"
    sha256 cellar: :any_skip_relocation, ventura:        "b62be3b6104a424852d3f670dee9f1c9114531be7e3882a84ce5ab6107897579"
    sha256 cellar: :any_skip_relocation, monterey:       "d1bcd890f9b77ed4a0ec4caf43cc9cba0c10968492328420487efcb880dba66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2900423c868dde472de27642d0f145d967a3457d9a0734119750ce996ef75b3a"
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