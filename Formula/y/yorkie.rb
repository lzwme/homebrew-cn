class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.23.tar.gz"
  sha256 "c54b7fe00e8844f00703bef1a1c29d4f2e5a141a61f900fcaed1edd6431d2ab5"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40c2f63fb0c3cd84ff83b1a4deb0b65d08721e7022dd8508321b363f58784af9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95b099d82980d7960ac5977ba66960709386e5acfdb9ce3857ba7adfd66d2c67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88220ffbe7727ba376f849a71e39d6dd078b14849884dd7018fe4fbfe46aaf9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e4403e2ae2fabaf2ba715a302fc7059a2cb17b8313f2e0087b55f8c34e17bcc"
    sha256 cellar: :any,                 x86_64_linux:      "ffed8bb0e961b6aabe6a5b3e94f81e0b29a442e836cbb00386d6e6bd92a08c8e"
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