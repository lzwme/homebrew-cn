class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.21.tar.gz"
  sha256 "22c1aa4a079723b7eac29928bc0884774088f34a2127dcf5e5cf5aa7752cfe40"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fe8ad706bd09b3bc984d6a3c870d31c2e695d954558bb2c72649c14b657580b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b352d0f91117ef77e7d9c7f85cde4aba7ed2c59014d6b2c295ccd842fc91d1e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2920dbec50a48518f4fe11d54b3d7ee0041c4925679bba4935d0daeec3cddf95"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1903fabc35072b241826aff7bb0f2446ad1d1e30d67f231d6cdd4b02f6e82a5"
    sha256 cellar: :any,                 x86_64_linux:      "37a00b97aa57b44229ed0b0f797bf8fafdc21997f3a58e6760003e97e1b1ff7d"
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