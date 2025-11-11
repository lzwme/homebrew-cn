class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.5.tgz"
  sha256 "0130b597a2537e5310b1ab4f5ea90c9f658117f8e6692684958b78b2a1c1b097"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "517bed5ca861a9f317f3f8f5fe94f672bb36e8ae5f5078489dfbedb69298b13d"
    sha256 cellar: :any,                 arm64_sequoia: "825d70315f35b1197670fe5505a002e957a4ee830fef87e621a0cc257573d301"
    sha256 cellar: :any,                 arm64_sonoma:  "dc8d203dbb6f7f556ae70169b4424d9e4d8a0556823194abb35ec80138a2d8ba"
    sha256 cellar: :any,                 sonoma:        "0a38e2d9e8a3f5172f90b6518317f2eddb9916dca76a2c2cbca3d10623eb88cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "525c5a9d58082c1e3254535ef290b19e75150fc007df5e0f706e4d95e47955ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2580949d70d5aafd9fc8daedac4061f64323529d6a23ab40225e1ac4719b797f"
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