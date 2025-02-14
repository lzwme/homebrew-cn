class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.104.2.tgz"
  sha256 "352562ae51bb88ea3b14da9b028b67c04e3ec1692cf29f98f86ae3b548915b23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "516191591fbdd59165563f3dcce9a09852085b7caf2f9a0dda8f45e672398398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa5218ecbe85657538bd67202d7647e3eab5dd533b8065439093ec336743927d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57992123932b5579169d7a8fdd6ca653de775edcca485b430423f0eb009fb4cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea3459c56c81895675d59004205451e21dc1bc9a51a0f16d1b2be9882566aafa"
    sha256 cellar: :any_skip_relocation, ventura:       "974c1b903de7f9fee81e60859ef84df96f1c215189aef8ffd49fa35261a35cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa4ea4c5654cc956175fbbd5bccb665d024f3f7a7e9f40cf11920b93284e3af"
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