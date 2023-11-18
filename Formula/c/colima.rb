class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.3",
      revision: "a9df8ba55e2ec9c5a9ecc4fb2ab941634b58ed3b"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94543c7a1ec1083c012f35ee2b3e539ba1649b92a273834f6c4aa63c20acfd34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9585dd47ca71f0c7eabb1f73c58fe20e69cc00e6dcb669cc6ceba21a846d61a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b266158fbecb839a1817a9dadd9d490c8172f21c1f3cd433b9ea2af8635dac4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0842e6fb64cad8ea89e58f32d959637e3781af5a7839c1977a51dcce867dea6a"
    sha256 cellar: :any_skip_relocation, ventura:        "9a0b3f93e6fa429b57019c22786ceafea35910998e9a4b92dfb768f9da5b2029"
    sha256 cellar: :any_skip_relocation, monterey:       "181b5fd60e8dbd491201b528bd72e1dede29c6d9508440f1d66c6e1cfb420e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c1fc94f86b35d44f89117472e05cd4f68d8e05ebb5ef715e886ce5b3fe6a6a2"
  end

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -s -w
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    generate_completions_from_executable(bin/"colima", "completion")
  end

  service do
    run [opt_bin/"colima", "start", "-f"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/colima.log"
    log_path var/"log/colima.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end