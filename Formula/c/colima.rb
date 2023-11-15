class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.2",
      revision: "22d7e5fbc86d5b8e3b27065a762800bc7960a0ff"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fc126e14e4710880f0d6a6a5123e2c4cee79dbaf625c41be2f5638ae00183d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80e15b206b7f288716519cb36874e32df070e396d61617d76d0ffaf013110b03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8213f3bc44712f98893ba03cadbf9fc7a1f239b0b3f7f950fb3361ca080cab3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3febfca9cf5d19544c9563e34598482e1bb94506f032d827350784176a0c1cf2"
    sha256 cellar: :any_skip_relocation, ventura:        "8cc9bf59ee04c49951c33e2f4ce2c6fb6142f0120925f7c01aa2493f86d9d7df"
    sha256 cellar: :any_skip_relocation, monterey:       "08800bcf8a659aa0840aa2a5585443b4cd0dbd13f0520865d73cc94449992db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "288a233b518721fe577ad340bad2718a2eddfbfe24a0c53fc2b8aa99613ea15f"
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