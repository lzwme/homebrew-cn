class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.4.1.tgz"
  sha256 "cbff06c15aec81066a42323e2c596a002c4fc2aa6db662e9e5e66da50e243329"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "b4ea12ddbfc2ebbe2a8594f75247e4af1062fc225f7a71518e9acad5af53d9f8"
    sha256                               arm64_sonoma:  "b4ea12ddbfc2ebbe2a8594f75247e4af1062fc225f7a71518e9acad5af53d9f8"
    sha256                               arm64_ventura: "b4ea12ddbfc2ebbe2a8594f75247e4af1062fc225f7a71518e9acad5af53d9f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b03f3acc440a3ad75049ab852d7edcfa1bec5038799c75caeb6b0758a6784656"
    sha256 cellar: :any_skip_relocation, ventura:       "b03f3acc440a3ad75049ab852d7edcfa1bec5038799c75caeb6b0758a6784656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04baee0425b4cf09fc04fcd49557f4405f20429cd1a24e7b323a24d5c1a07e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50343bee37cf06caef3e167cfd38aabf12b7bc9bb0e7261844e7ddf480657804"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    (testpath/"test").mkpath
    cd testpath/"test" do
      system "git", "init"

      # Test backlog init command requires interactive input
      require "open3"
      Open3.popen3("#{bin}/backlog", "init", "test") do |stdin, _stdout, _stderr, wait_thr|
        stdin.puts "y"
        sleep 1
        stdin.puts "y"
        sleep 1
        stdin.puts "n"
        sleep 1
        stdin.puts "n"
        sleep 1
        stdin.puts "\n"
        sleep 1
        stdin.puts "\n"
        sleep 1
        stdin.close
        wait_thr.value # Wait for process to complete
      end

      assert_path_exists testpath/"test/backlog"
    end
  end
end