class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https:github.comopenaicodex"
  url "https:registry.npmjs.org@openaicodex-codex-0.1.2505171529.tgz"
  sha256 "b4ddf4cd6e179d640d800cc54179a6bfce80fbd3585e086ee1684eaeb831629b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db2cde26b9899be08646088d24de0fab878ada766fa75831de6f5d916ec8ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3db2cde26b9899be08646088d24de0fab878ada766fa75831de6f5d916ec8ad5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3db2cde26b9899be08646088d24de0fab878ada766fa75831de6f5d916ec8ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd0c3144c8071850fc1e40f0e145e98c5c84b0dbdc602edfa5ebc9679eaa77a5"
    sha256 cellar: :any_skip_relocation, ventura:       "bd0c3144c8071850fc1e40f0e145e98c5c84b0dbdc602edfa5ebc9679eaa77a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3db2cde26b9899be08646088d24de0fab878ada766fa75831de6f5d916ec8ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3db2cde26b9899be08646088d24de0fab878ada766fa75831de6f5d916ec8ad5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    libexec.glob("libnode_modules@openaicodexbin*")
           .each { |f| rm_r(f) if f.extname != ".js" }

    generate_completions_from_executable(bin"codex", "completion")
  end

  test do
    # codex is a TUI application
    assert_match version.to_s, shell_output("#{bin}codex --version")
  end
end