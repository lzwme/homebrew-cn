class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.116.0.tgz"
  sha256 "7052d6cbec578dd9a0833465c1a62b6c4e48098b32ea4642fb18722a9ee8fb0d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a79d54b26670598bcb46af740fc8391734fc014687227cd55469b7784ed55e0d"
    sha256 cellar: :any,                 arm64_sonoma:  "93214be1bbf6de69a8d1a233263a56590d30e26a0331ae0bceed29d02512a34a"
    sha256 cellar: :any,                 arm64_ventura: "439b8acd218ea73b52282ddbfe2fa7f0e0bcc431b38d7f585a0a99d461fec2f5"
    sha256                               sonoma:        "269adfdde88f314aff591592c38f519363ec4ca6adccc293f010af71aa42d0bc"
    sha256                               ventura:       "dac984b0e95163c124c249545b79850ad68ae7169a7cfa91f9c099c59b29acb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a57a1db2c40bc87d13a26a6d1de0a77c0c6bb59ddba9c5524e3dbaa1f022cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb2b5b97b3a127748870333265329fe0af26122bbc8f0498952182a1d2fe601"
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