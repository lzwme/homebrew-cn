class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.2.4.tgz"
  sha256 "79206742a7bf66bd38c0fe1ee6d6f8a089e783464c3909062e8b370f89e0845c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "0d7b0b9aec41acbffe6f257acdb33b51573d6d4d7ca6353f8e4fcc353e216017"
    sha256                               arm64_sonoma:  "0d7b0b9aec41acbffe6f257acdb33b51573d6d4d7ca6353f8e4fcc353e216017"
    sha256                               arm64_ventura: "0d7b0b9aec41acbffe6f257acdb33b51573d6d4d7ca6353f8e4fcc353e216017"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ef66a5fb33e1f2165bb71bbdbd3fcd72788148dd8341770e5a8cf9daafdb38"
    sha256 cellar: :any_skip_relocation, ventura:       "65ef66a5fb33e1f2165bb71bbdbd3fcd72788148dd8341770e5a8cf9daafdb38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fff6b7a8054036f7ae684ca306daddde0b72085744e98b96d3b796bfed5a4bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b474ad245cb26768ec133fa91753ff6aeed4e4735b8f5757556d4ebb3f63c672"
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
        stdin.puts "\n" # Send enter to proceed
        stdin.close
        wait_thr.value # Wait for process to complete
      end

      assert_path_exists testpath/"test/backlog"
    end
  end
end