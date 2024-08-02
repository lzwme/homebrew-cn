class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.9.tgz"
  sha256 "e2a20c6fed7cb45a06a634e91a6a2a745b44a97456967a74cdea2313f24ec30d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "492cc1373fa8ad086bdc753d5d375358ade00fd218a0e6a674f70218a7204162"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fce1ddef057e43b917aee8176403bdff9cb196b4bd32e1d9e1bddc2a926fcff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b11da4a8201478cf674264a1f3d091d048f2b22dedc6ac4289944da8f12876c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5348a30d9b7a7d672889dda278e7d8e063fa1e2bdac2a34a7c0ea2e3e9d9b6ad"
    sha256 cellar: :any_skip_relocation, ventura:        "eb48ba36ce50d017a6ed226b9e0b98f4025c0c6796873b52e96009250989b913"
    sha256 cellar: :any_skip_relocation, monterey:       "ff143102546290c6410b3cf0c1fb5a2e9ad3b9b3b9f743285a6da7aac4674e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf531b4ab562e57636d731e507e44f22917d52b4e01a08888ba9eacce61c52c4"
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