class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://ghfast.top/https://github.com/alebeck/boring/archive/refs/tags/0.11.6.tar.gz"
  sha256 "92ed17d6104a3b8ab4db31197b8313fb2ba87d3b7a4368a03cc8198b874b1683"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2571b20c935be9a372248d834e41162efbe0425126d67e706d5c85da827c871a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2571b20c935be9a372248d834e41162efbe0425126d67e706d5c85da827c871a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2571b20c935be9a372248d834e41162efbe0425126d67e706d5c85da827c871a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c76d623c4718d4f0c97f4f99cf581d81bc26219e806c5852cfe3bcf1dcb1b430"
    sha256 cellar: :any_skip_relocation, ventura:       "c76d623c4718d4f0c97f4f99cf581d81bc26219e806c5852cfe3bcf1dcb1b430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb189556f204af42bec483d424886daa4ae28bd020670658fb9340ae18cb2682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af7a0aa863050b9b812e73d6351643c930ccb4a746b2b773bc748ada3ada0807"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"

    generate_completions_from_executable(bin/"boring", "--shell")
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/boring version")

    (testpath/".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"boring", "list", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "dev   9000   ->  localhost:9000  dev-server", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end