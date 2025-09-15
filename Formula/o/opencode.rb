class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.8.0.tgz"
  sha256 "d2274dfa8b76e1bdf1912493b2f10d9797310ac8f03cfe59570e7ce5f7f77335"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "793563fb581e014c5fc1d2295a755c876738c2cd6511c41e439b81008e3f47cb"
    sha256                               arm64_sequoia: "793563fb581e014c5fc1d2295a755c876738c2cd6511c41e439b81008e3f47cb"
    sha256                               arm64_sonoma:  "793563fb581e014c5fc1d2295a755c876738c2cd6511c41e439b81008e3f47cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2471e99b3e865e5e35e219e0c00ac04ee2d58ee518804c988feb622644114b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dd5fd3aea0713452b91f2cb35b451d3a950c8c4795dcb7dc34c004b7984c3a4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end