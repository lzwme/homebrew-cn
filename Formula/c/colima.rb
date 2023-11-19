class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.4",
      revision: "0f4b7f694514d1bb6b4ae0e33f2d56deb0e7b1b5"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "078c75fd5ac21f88c391a08fac44fa41fb3676c4fba03313547e801c400f4198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "573490e7fa82e89b21e4078745abfd8c1c4b4f22934680371daba6296ed670be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ee3c8edd8e7a151562620f5342b7e61f3b53cb230c6eabcf8db45eb24265d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "472f9423cef11c3a7ac834cddae8a3adac05670be3fcece3a3a311c7578cb5fa"
    sha256 cellar: :any_skip_relocation, ventura:        "b4711144b366b5e657e50b7867e2e5afb2fbd52b8390c4247467517cf4aba591"
    sha256 cellar: :any_skip_relocation, monterey:       "c40aed2b2fd5ba08e813afcf3e2e3e5b27fcbc2d3ce0ddb6461d2087f83fcf22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a72291515d3069b0687861ca1f063cdb46320f692dc403dcaf12f269de6e872"
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