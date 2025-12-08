class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.27.0.tgz"
  sha256 "7c49e787899030a577dd71ec9c25629c8955ece4582246705ed8cdedd06ca0dd"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9e24f6e24b3a996b4c85b2040a394dcd3c9524470b88c9c6a07fd63d333324da"
    sha256                               arm64_sequoia: "9e24f6e24b3a996b4c85b2040a394dcd3c9524470b88c9c6a07fd63d333324da"
    sha256                               arm64_sonoma:  "9e24f6e24b3a996b4c85b2040a394dcd3c9524470b88c9c6a07fd63d333324da"
    sha256 cellar: :any_skip_relocation, sonoma:        "291698f7d540260346de0ccb1b5ec2e7674547dc1a3d5bc476eb911d2655251e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c84a2a4650ca7d4ae01dc8416b44f835409c3caaf34022ba9861c08a9e910582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce7b0089053ffe1fee4c9973b5604cde1e2fd46c1f13a591c3d61f2894af2e11"
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