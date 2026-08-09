class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "2ffd4822539cbbbae2c336651b86b19a60dc8c4e94e42a891590658f1f425cd6"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "145de897cb2667298d1be89cf6326ee59a3bb2cf97195176ad3963f3e4fd6590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7cf13b606e3c598d650f34cf5ff08dad238496616fe01d45c9554023843eff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a713dd9103f46d5388d8bf41eccc329390fcd273023ba0022aa7f58c650d0f17"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa800c76c7bb5252fd85dcf0330a5370ff612fab4edfea5f9fca8849fb050488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be0a436ef44ef6694f52e2bc02e388eefb836004f73d46f17da092aa80afa40"
    sha256 cellar: :any,                 x86_64_linux:  "21b5fead2cb82bb62ead7ab5b7e515c1da82ce26e89b69457f3d358079689406"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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