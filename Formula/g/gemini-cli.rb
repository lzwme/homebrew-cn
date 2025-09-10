class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.4.0.tgz"
  sha256 "df8e64c6ed42166d92ae09268516daa6144a0cfdef24c754ffea144f7af864a3"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "cdf87b24abed3dad3c1258a5af5160f99469fdbf43839cd2e7e4d00edd7da603"
    sha256                               arm64_sonoma:  "8914b4615bda7b40718ae76239c27e988da10aa0dfdda4a8591546f4968f7ca2"
    sha256                               arm64_ventura: "c9319bc481981d4851521edd357b0bfaf091a3900f327262a726e91374069737"
    sha256                               sonoma:        "efc6747930c6d4d1b7cab5b9c48e87866dd6cbf9e3c611abe42d484d71d3af14"
    sha256                               ventura:       "c92f22c6077fd6a59eb049d040ecda1ca4c1bd563e078d1a858d0fb88ee76748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a44db9ecce6fa90509948e5af76a185324ee3bc9f30e642250446a129755975"
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