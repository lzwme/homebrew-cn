class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.17.1.tgz"
  sha256 "e78061a2d27a8f0257d918c698e3ed166e57b0d8ed2f6c68d68d6d8955674bf5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "adad4512a97f7b3101db6b3f207bc1456869b2102c11b086c45d2043b0d281ec"
    sha256                               arm64_sequoia: "adad4512a97f7b3101db6b3f207bc1456869b2102c11b086c45d2043b0d281ec"
    sha256                               arm64_sonoma:  "adad4512a97f7b3101db6b3f207bc1456869b2102c11b086c45d2043b0d281ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd9c75533cf408ee2c05dcc8d14f4428b0dcbea2d0f5950998707eec46ad1069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa2774c090536e7675fdca20b491028f60fcec270ead5b03178ea926b506dac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e809b72dfb997e794ba6e1583b35d5c2dc65201807000e46ad0818e19fcebd"
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