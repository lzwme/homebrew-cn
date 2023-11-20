class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.5",
      revision: "a3adebfcd9da8c85614d81030033d02f04908a79"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccc3d5251acad079b0266d33f9becf76a07654d0ecd93e2e14473893199a5f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15abca451bb2613f78e113dff794ae1d6e866138a63cd88bf0fb0f51ba2ad9b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8a617f4c01802106e23e85d3d0dd4b7fde8127f12dfeb48906d6bd2cd452a36"
    sha256 cellar: :any_skip_relocation, sonoma:         "992cd8e961dc1058e8d463985c61c0080d4d244c84501c5ed5e05bf714082df8"
    sha256 cellar: :any_skip_relocation, ventura:        "d52e90cfd8acf322c015d3570962c368ef1cce059930e9e40aaed2e9d4d773a0"
    sha256 cellar: :any_skip_relocation, monterey:       "467b4038f4146e9c5230fe87e342b69894b6b171f55b6f21c376e00155b9c9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a163989af09b08a260ac4e8f9bbee99c93ff6a8771d09ef4e2235ff4efb94ea"
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