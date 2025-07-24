class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.5.6.tgz"
  sha256 "b6ad107b6ca18104dc2f43bdf63e6e7bf5bb0a537f3a9a26b9a142a21d03a1a4"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "426fcca493e4a0a68dc8033de3698e6636c486f1bf38e1f722d9007ad8119a80"
    sha256                               arm64_sonoma:  "426fcca493e4a0a68dc8033de3698e6636c486f1bf38e1f722d9007ad8119a80"
    sha256                               arm64_ventura: "426fcca493e4a0a68dc8033de3698e6636c486f1bf38e1f722d9007ad8119a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "a200e90b6282b00395937a5bf1c3b4e234606ed50eb823a3bb8d0cb44f41c997"
    sha256 cellar: :any_skip_relocation, ventura:       "a200e90b6282b00395937a5bf1c3b4e234606ed50eb823a3bb8d0cb44f41c997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66a3b2b903bb010a1a674b5ec3e0efd33d1bef1739d0dd9393e49d80f08d14fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582f0ec7eb8c681cb28a753544d03a66e27dee9125b4a43a8d95c0850067cbf8"
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