class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.5.0.tgz"
  sha256 "d163a3c3efd067693cb1da5799b3be3ed4953207db21fedc5f8574ded875542a"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "2052b16543a55e0271beb0ec551eb0708973cb35b42d8d5b9416fa39ae09ebd9"
    sha256                               arm64_sonoma:  "2052b16543a55e0271beb0ec551eb0708973cb35b42d8d5b9416fa39ae09ebd9"
    sha256                               arm64_ventura: "2052b16543a55e0271beb0ec551eb0708973cb35b42d8d5b9416fa39ae09ebd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c184e045e6f59fb0b3252689e1aada1aa1d3b53c3f6da0f3c34a696289a2a71a"
    sha256 cellar: :any_skip_relocation, ventura:       "c184e045e6f59fb0b3252689e1aada1aa1d3b53c3f6da0f3c34a696289a2a71a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e41ee83f359091e600e1dfe5acaa215f015a416194a73e187630da31605bba7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d3fe33a2650e35422f7f52428c6da615675e4302c86a26be7baa9d0d8b411f"
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