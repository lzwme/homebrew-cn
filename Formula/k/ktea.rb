class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://ghfast.top/https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "7e864353a38e5e6500f1ce84e7f5f12cc1e3e53800d09ec22a87d4054ebcbca6"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bccdcb30a299defdc25ea3d45b93676503c19657a428499ab7b69058576e148b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bccdcb30a299defdc25ea3d45b93676503c19657a428499ab7b69058576e148b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bccdcb30a299defdc25ea3d45b93676503c19657a428499ab7b69058576e148b"
    sha256 cellar: :any_skip_relocation, sonoma:        "90bfa975b0f8a63884d3e9bce8ec3a4f2cc76ad3df58185bea0efdd0ab071ba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "515e7f368a823cb6d9a397d18c712be1847409d7372e93922417cb9e4842dfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28d20f839d9edf50ebf275cd4b106ce1e78c3085ae3693ed50bac08a3d609ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "prd"), "./cmd/ktea"
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"ktea", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "No clusters configured. Please create your first cluster!", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end