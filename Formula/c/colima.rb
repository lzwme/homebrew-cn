class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https:github.comabiosoftcolimablobmainREADME.md"
  url "https:github.comabiosoftcolima.git",
      tag:      "v0.7.6",
      revision: "3ab92f54210503770223a8c9bb61662725e23004"
  license "MIT"
  head "https:github.comabiosoftcolima.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0949b56303e3cf78795c24baa9730e1ed1e802affb7ef21023d352c0ce5c3ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fe4c1483a6a9616073ac7bc04172e4afe6aac9101750d434fd47a5d2a1022a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54cee2a5a6bb223d44048d037607e682c6c1098d95fe71940a0bd228b6cf5789"
    sha256 cellar: :any_skip_relocation, sonoma:        "59bcfa7e5d8264740ea616db59b3baa1db41ac8de7ed044800b5a2417c9e56ba"
    sha256 cellar: :any_skip_relocation, ventura:       "39ba772f61d31e529f377c404f7ae4c58b01358a3bef426daaf8229b1fb0844f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b469b8b84c00f1f2c1d29ec54d0aeec93839d791ed70e1b4b337ec956acd2c6"
  end

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.comabiosoftcolima"
    ldflags = %W[
      -s -w
      -X #{project}config.appVersion=#{version}
      -X #{project}config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcolima"

    generate_completions_from_executable(bin"colima", "completion")
  end

  service do
    run [opt_bin"colima", "start", "-f"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env
    error_log_path var"logcolima.log"
    log_path var"logcolima.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}colima status 2>&1", 1)
  end
end