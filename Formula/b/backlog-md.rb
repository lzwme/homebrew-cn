class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.26.4.tgz"
  sha256 "fe2e17bcd9a76033bf81b0028532d9d1a3939a57a1d3557f2b1a95e03ca87f08"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a06708de1015a24541b7165bc64f1afe9a128df10d21e51040e3d2ade6e95cb2"
    sha256                               arm64_sequoia: "a06708de1015a24541b7165bc64f1afe9a128df10d21e51040e3d2ade6e95cb2"
    sha256                               arm64_sonoma:  "a06708de1015a24541b7165bc64f1afe9a128df10d21e51040e3d2ade6e95cb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cccc3049a4b85bb13b15db06c8b3a281fa747b2536ddcfc936dc2757b99e4c28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1582c44355774d8880c3c44d7414f128779de74f75c2f3a1bf72800bf290d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "035c3a02ce79d0173da2a10aad9183bd0094e8ef46345a9b1785b6cd41ab0a6f"
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