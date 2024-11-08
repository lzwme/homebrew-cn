class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https:github.comabiosoftcolimablobmainREADME.md"
  url "https:github.comabiosoftcolima.git",
      tag:      "v0.8.0",
      revision: "9c08cff339f087c0600d9d56af7b5fbcfe02e287"
  license "MIT"
  head "https:github.comabiosoftcolima.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd94b392c236f4d5d4cc26ce8f495df1e6efa07d1f75ccb07accb4079ef59606"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ba14eef41c80f216f62b34d006c946ec7807cce09ec3e8e3a4b83ada92c16a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e9c2885b94bdf64c615beaa428954f43499b4c85b2b8ddb9c97a96833154c87"
    sha256 cellar: :any_skip_relocation, sonoma:        "392f2a5a29bc1ab2a5ba912d926ad38bba64855d8b541a1c277121858c6706b3"
    sha256 cellar: :any_skip_relocation, ventura:       "d6c06b47fea19d6b52038f84f612cc2dfe8e479cae3c721854b4938974a1ffb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c70b220e93a34d0a63aed7dbf116c6a1593d498e2a79887a332d378bf61eac"
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