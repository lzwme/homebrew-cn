class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.5.tgz"
  sha256 "aff74f62fac8b896ce0318341141357c89b5109bf404dbc43e3a5b998759cf96"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "81379dc48f348e646b10826efee76637147738a99e8590b611007967acc1f08b"
    sha256 cellar: :any,                 arm64_sonoma:  "18a6316abbe6976575bfa9c6e2742688d3e12ad0f94f3f7aa1041bef9964b33f"
    sha256 cellar: :any,                 arm64_ventura: "dbcf2e563a465ed88be05f493019cefc54af156bdc41647557ee08c380e9e36d"
    sha256                               sonoma:        "395d847026b62255f83fdeb79fb734552bb5c864d3a5a85bc6bf73163b7cb057"
    sha256                               ventura:       "09823354c0f98eac7005d5e9499fc0e277117a72ef81f64d2c30a036ee2b823f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69b0fb2b996831255898ad71e4d1a008a7c8c44c8c207111293ee77747ecadb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b940ed767baea76e790cc6c377f11c55ab6c64031acb58bb4e314164ed16b97"
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