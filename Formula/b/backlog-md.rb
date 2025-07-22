class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.5.2.tgz"
  sha256 "15d3123a3c704bcd001f7e5910fa1ac5a197473ff4d663bc73a4b4d5c5d54412"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "c31ef3871b265de610625f7e3a44c3c1928c42fd9783fe8c84a7b316df719a31"
    sha256                               arm64_sonoma:  "c31ef3871b265de610625f7e3a44c3c1928c42fd9783fe8c84a7b316df719a31"
    sha256                               arm64_ventura: "c31ef3871b265de610625f7e3a44c3c1928c42fd9783fe8c84a7b316df719a31"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9b4fdf6797406bb90d50e98b67eb0aa158ca64a3a82357631a7407b199e744"
    sha256 cellar: :any_skip_relocation, ventura:       "2d9b4fdf6797406bb90d50e98b67eb0aa158ca64a3a82357631a7407b199e744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da9ed17d586db6fe4e59e106c460e23190bbf1862aa46c2637506eae73445f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c094e8d66bcea7163ea3965f1418f754e13ae4e6b5818610c1e9f875ea72be"
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