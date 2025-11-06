class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.3.tgz"
  sha256 "8d9a3078c8a32c86db134ea1dfff55a04c5fe464e05e382d9523230b9847570e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6aa105d45b8090e938dc8c10814851388bd6405f2ab6ea24887b1dfcf406f1c6"
    sha256 cellar: :any,                 arm64_sequoia: "64b334a672b976b8c1a7ffa1cc1e141d085a142fa8dc4b603402388b8c180eb8"
    sha256 cellar: :any,                 arm64_sonoma:  "473867267238519f2cb62442c8b53883f50d1b568d745b16ebddedf985ed6e35"
    sha256 cellar: :any,                 sonoma:        "61599b2772d1ed563b7e2844edf59a6a64d5d23dea5e79ababe5dfb32123bfb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f4efeb66ab889cfc81501da823af78c9aef3b8cae41e7c7249cc8e1d8254220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58baf4cd4d2b4899e69b51ae6018a667dab77450734e85a48c9fb7f889b50728"
  end

  depends_on "node@24"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end