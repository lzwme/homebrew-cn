class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.6.0.tgz"
  sha256 "e87e4a186b669af125d0f9993cbe98f8bf639f1268a70a233236de68fbcfd225"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "209eddb142dc3f2d6b19c480413af92b37cdd2e63a19ca07f8161b8ce934e789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "209eddb142dc3f2d6b19c480413af92b37cdd2e63a19ca07f8161b8ce934e789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "209eddb142dc3f2d6b19c480413af92b37cdd2e63a19ca07f8161b8ce934e789"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff05e652b2c6b4fa62fdfc2246231e9b5b07a16a2ca1ad1f3a548ddbeb6c4ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff05e652b2c6b4fa62fdfc2246231e9b5b07a16a2ca1ad1f3a548ddbeb6c4ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff05e652b2c6b4fa62fdfc2246231e9b5b07a16a2ca1ad1f3a548ddbeb6c4ab6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end