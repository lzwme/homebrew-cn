class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.2.2.tgz"
  sha256 "5cba2f88c33f809dfcdc3e46490da05aca7c3fd121c6340b6e040398dafd1612"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "cab819174538f9b95ce047abf9be4136e807248ee0b4133d5686922053f38a4f"
    sha256                               arm64_sonoma:  "1d5b547caebfd8a22d73cffa5b9e177ef992c24eddf8a7704ad5401b42b9cea3"
    sha256                               arm64_ventura: "0da2c2248666b4719a0b8458f5d366e2f878f8d0b123b11973bc244f0bd2a5fe"
    sha256                               sonoma:        "484f963dd7f1849b2a422e668bf55fae8ac562ff35e4f467a0b4993f4e19c81d"
    sha256                               ventura:       "235a7c0c0fa132c1fbe1cba29d32ec98f210abfb90484c21298464a7aba5865d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a898955a338a3d3d7a16217ab68830e3d36c808b22da773ad3087afefc5066b"
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