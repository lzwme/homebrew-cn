class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.27.1.tgz"
  sha256 "eb3807bcb1c86d037c0770db8f27b378fcea995fce376fefa48dbcb9647ae868"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "900a39acfe3c3dd7e3cecd284a4599f342441caa85244876a6b7cb83cef7c37d"
    sha256                               arm64_sequoia: "900a39acfe3c3dd7e3cecd284a4599f342441caa85244876a6b7cb83cef7c37d"
    sha256                               arm64_sonoma:  "900a39acfe3c3dd7e3cecd284a4599f342441caa85244876a6b7cb83cef7c37d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a150e32ed4585037ebee24ed80b6286d0affabaf911cd6353ff5e8c418cbb64a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23399fb8edae0db19437d195b73ca6e29d671afbc1f948188acf8c70609184ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16c10aea0aca7867fd9bb1ea95483e14a8e4e9ecdd24b4fc9e1077b226c625a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end