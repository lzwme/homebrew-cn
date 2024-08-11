class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https:github.comabiosoftcolimablobmainREADME.md"
  url "https:github.comabiosoftcolima.git",
      tag:      "v0.7.1",
      revision: "ce7b155dbeb7843ac0d9966a6ad19dc8e3b56bb8"
  license "MIT"
  head "https:github.comabiosoftcolima.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecdca45f31c085a2aa58a69ff84a4d659d4f3efbd10ce339580ef56eccf873c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f2259cd4404c27136f5f90a74a7c0fc9a2e7da99d5c76f1b9a5cc28e7933994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3cf213f3afc5e859e020b006cee0a20ce253e8277f7720a5058a69def77768"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4c127b23eef44a7091cdc9dcb68cab793d58d74a6893f3e93c6542a80e126c8"
    sha256 cellar: :any_skip_relocation, ventura:        "e82e2ad2e8abb7837059d40a9beeafa74b6e451fa3d96a511301e0319048d02c"
    sha256 cellar: :any_skip_relocation, monterey:       "485ec53eea7c20d88608083c8aa70db4127fa84505b3c99f957d4b815ec70d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af00b26128fbdae53f10ba3f68bc1593e6b511b565a84e2a3c042f4ac81fca64"
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