class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.12.tgz"
  sha256 "053e937fb74f88b1410fa29636a2447655356dbd727d5f8ea16668df3ce3d496"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "acb733264a501081b31891f86e44490bfe89ebe53285165f663d2a5cf6efc0bf"
    sha256 cellar: :any,                 arm64_sequoia: "95004cb4663149ead16461941106715bc0a840936d7baf468ecdf2506615b6cd"
    sha256 cellar: :any,                 arm64_sonoma:  "0ba7ce76b132dadf096a3fe8622ed7dc6b0297276763f052ec97e3bc960b5004"
    sha256 cellar: :any,                 sonoma:        "f7af390423be8917b3ebaef1df62838f68fd034432b05e88503d1cebe289081a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0026f330cfd68e305275ba0d8ef3b802a31ae32b89685df1c297f1ea1f1eb8a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac931a05b9ed9198698afba42e4d49892f21c689d82eda44165a8d8d1688a3b2"
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