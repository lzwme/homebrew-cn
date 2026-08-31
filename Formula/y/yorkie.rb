class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.18.tar.gz"
  sha256 "37e8e810fa0027d2c687dc71fc524bbcc6b11921b497fce546a2fa3c2838bc7d"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0660f12bc8564ccb4e3e89045615dbdf3203181578e7b105d0b627e1592d796d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "089ebbc0bc329ee679c8fc9c0dfd5f87baedf2c58a8b66bbe49dbe3130c4c27e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8424f31cd8654095263fee7290c07dc1b5becc8b95a53a2e6e99df47156c9365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "430e2875b95e6e0cd07c30018676c8e166e0a1c8ea2196435d04ead101e14a68"
    sha256 cellar: :any,                 x86_64_linux:  "43d6dcebedc2f18e1cea245048308767d76045220e6438a8ad66024c51b54a43"
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