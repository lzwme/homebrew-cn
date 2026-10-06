class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.24.tar.gz"
  sha256 "7584ca442943851f3287b22ecc38d070e28cf0aaa8c96565df9bd29b88fefb0b"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26928ff8542852f6449d11a8f1ebdd72e8746cc016fb0bbd3678a5f07e78cfa0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef83a0cb75961c9bbf95eabbe9a185d64e955172f12c3b4116bb6dbbcdf8cc29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46708a2dd71be3b45d662768185f6136b00e6668c6b0e9512debf7fd8e57b262"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa66138ff45b32499a0a0320e5552dc5a3ba6366f0db9fef41230647e471e85f"
    sha256 cellar: :any,                 x86_64_linux:      "7af19a5cda6586f52b2ab1a43d4f40f194a41368001ab9ec99c5690a4acfa02e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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