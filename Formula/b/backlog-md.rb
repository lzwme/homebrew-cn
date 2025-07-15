class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.3.2.tgz"
  sha256 "5c9a26c55d277e79fe5568ec3db9459ceb07274b893e87a17cddd603f9c5e891"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ca44eb0058580295e4e1cf44aa900436634a47ad190e570b0e098f4bcbb2f868"
    sha256                               arm64_sonoma:  "ca44eb0058580295e4e1cf44aa900436634a47ad190e570b0e098f4bcbb2f868"
    sha256                               arm64_ventura: "ca44eb0058580295e4e1cf44aa900436634a47ad190e570b0e098f4bcbb2f868"
    sha256 cellar: :any_skip_relocation, sonoma:        "df8bf6695062b42411c590cce12d1b283b2fb588b8a46684f6dd22804f62ac99"
    sha256 cellar: :any_skip_relocation, ventura:       "df8bf6695062b42411c590cce12d1b283b2fb588b8a46684f6dd22804f62ac99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddb707b311c3a4193e0db7678d856f14a9f2afa1edcacdb505084ad7eb1a4e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02de399501055ac87e26c017b62bdce1974a2fedb3db8ce8f6dad5412849fb48"
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