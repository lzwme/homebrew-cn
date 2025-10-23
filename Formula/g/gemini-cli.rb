class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.10.0.tgz"
  sha256 "2dbd623d48c7a51aaf68600b1a541ac9c667ef7263525f44fa701348a0a0e147"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "7633d3776c834c9e3ef0bb32ae1f90afa3d944895847b02ce87f3f7c4db991c4"
    sha256                               arm64_sequoia: "e73ccc3f8c40780fc49bd02c31bca0af1da6377d183c0c251ab1d48cf477d580"
    sha256                               arm64_sonoma:  "002ecb26b2e61d6b915e6b0fdb3d591255d6401b09a04a3c30ddcaaa59513f81"
    sha256                               sonoma:        "d87057dd872558778d6ba16f1235f5cf449b66fe77f9b5c6acac55134f45a6df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3604d62e7b2dfcd4a3bfd5eaa817d0c306aba527673a3de2442c39df97272a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec2d1dcebb2db2b3dc52faed000cdf849aa56a9f670580f2396f536a72dc13c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end