class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "e7f39611632970dc6cbd30873d76ca11b935174de03caba85292bbb90ef0d557"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ac10e8fa2a73400efae7612d13896f697e9fab6f24f97e5339f08082d28904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e4df7cf5032c69938f6c8873e25cc83460157962c003ee88c1b3178792d6604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e12c37f8493a4bad5c87b59a8958035c144ada2234f7316017b7cf41b9b6f6f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "746be3afa0bcd454d76605e7bad8f69ad5dbafe7962ec84ddeb8e8f2483db379"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c63a1a21fd437599bd2160f9e8f7eb1b552a7f46b9b3f356897ea138767ae33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1d8a4708dc50c1c52aab1da90caa1ba5cec956f9fcb73a8bcae7ada989fe0b"
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