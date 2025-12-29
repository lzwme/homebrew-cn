class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.42.tar.gz"
  sha256 "7446ad0ffbc08779d5033f968eabe6a93aa4bba9b6fd2942c7585100cf20c841"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb90f7876477356042b6aa484942d93437613e42d95183f6a27c6786bf7e289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82b434c7dcf0cc82f26893df4b7d97f9f5034459228fa169e6ae17c360831aa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e88bdbb152fb0a75ae94eb1f9b3ad623d7937a583af1b361558f9b90d6929ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "c12d0ebee18f4e5200938080f785414b86ad1a98dbe5cf950905e29eb05f6ccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "572471c63618e9cfc0813b1a51c4a9813c215df65dffc9d42cd25ce8e2373fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c324125d91026045390e1a7a8702187c30678072190cce0f9ce2e689d18c8982"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin/"yorkie", "server"
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end