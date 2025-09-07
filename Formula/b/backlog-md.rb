class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.9.5.tgz"
  sha256 "8bb12f1b3efe41e2297acac3f168da63dfbdf158332b16861e00248e92093053"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "95d72d162d708fd0900bf027547f5bdc1fd57a11cd31386c4f0e56ef4384dd4f"
    sha256                               arm64_sonoma:  "95d72d162d708fd0900bf027547f5bdc1fd57a11cd31386c4f0e56ef4384dd4f"
    sha256                               arm64_ventura: "95d72d162d708fd0900bf027547f5bdc1fd57a11cd31386c4f0e56ef4384dd4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4034608e6cb743e6293174b3e646b37bb355bb09e08bd8515c51004896c5de39"
    sha256 cellar: :any_skip_relocation, ventura:       "4034608e6cb743e6293174b3e646b37bb355bb09e08bd8515c51004896c5de39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f07eb9835b41efd99a0bd92582e82530ac0f927cd5b4bac8e0173ccd9beac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9987950115a27b7534fdb5eb82d94b4d0a69feb8b045278ccafe46f410fc96"
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