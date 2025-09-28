class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.14.2.tgz"
  sha256 "22f263f5c4426b5a5add580c91d84f1c03f681400d1f0efdd33e0ca115d937cc"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1c605e7e1ea0f5d515e6dcd690b474edc743deda074241674c67d0f7f4278325"
    sha256                               arm64_sequoia: "1c605e7e1ea0f5d515e6dcd690b474edc743deda074241674c67d0f7f4278325"
    sha256                               arm64_sonoma:  "1c605e7e1ea0f5d515e6dcd690b474edc743deda074241674c67d0f7f4278325"
    sha256 cellar: :any_skip_relocation, sonoma:        "4926afb1283df0d1979b4aab44fee72fd7f0e7169d3df11182a74bf5947ab04d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd02ba71c2f41cbff1a9fd6e617da78de36e0d5852a84ee80d51cb28f2dff69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a289a4e30942abd62167b8e0779ad1e24cfe28b59ec4659c688b62c04f0ec49"
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