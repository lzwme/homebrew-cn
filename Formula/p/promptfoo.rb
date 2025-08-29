class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.0.tgz"
  sha256 "10ebeae8f7c095b371333d37a96727de27cb4aca9248f076d6a280ab3c1601b2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8f343c15bb32b9538d90aa2188fb441f67b3eb08554b7ddf00c9855d30d9a82c"
    sha256 cellar: :any,                 arm64_sonoma:  "f6ca7a29b2dcd028a311c9f9b3663bfc01e0b0f2b9b0ba708b7b0cf3396f344e"
    sha256 cellar: :any,                 arm64_ventura: "2d80d2be066b4b48232d47585b2122f0ec9272769b17dd6f5f09973a45b832c3"
    sha256 cellar: :any,                 sonoma:        "d0ce89a7200f6db3c5587bd62a4637ee735ba8b136e9989ef14a4cff2e2b37c8"
    sha256 cellar: :any,                 ventura:       "a603c18c79e1737599f44c1b1fba0ff4ce2a8a7fe3aa82f9b5130aaeb4c0e04a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cce14838585c903fcae4b4b96acc94504daed1ec1cd7d390a7d348f637068134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cde72ae3755f29e2ba4a7ac1d98c0d082d545f4205df0f86fc33487aaef6dc01"
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