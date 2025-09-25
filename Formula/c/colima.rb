class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.9.0",
      revision: "4481eb78a942f1eed7d053132233b344aeb8cbc4"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20d6d54ba8f37a92120d3e620301884a69af880c95eea200611bf3261e85b89f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a17e3fd254e12d2c9e3bb58904866f3069de11102bc0f1b04c01ad88fc41eeb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e576892da13c9e64c9f77488b2041d5603a35dba0aa64261d4f7da375b2c1316"
    sha256 cellar: :any_skip_relocation, sonoma:        "81646cc16d83126fc64068d66fc3d79638d9e1882c8d0f47c9eee13e5df078f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "362aaa3b6d5caaca1235297494718e1271805585e50488c96b15a8691ab0adf7"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd/colima"

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