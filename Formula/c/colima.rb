class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.6",
      revision: "9ed7f4337861931b4d0192ca5409683a4b7d1cdc"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c310d78051c43b8d70b932ebfb2f7b95496f17c751b3f3703fa80731be2aaa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962851dd4071d3a3fa40129db75924b977041728663887ee58c09fe44c7fefdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c02150d0592020d64018187522f23593e287492216e8f690bfb69654e2870f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "36b24fa12c489a98f205cbfe303b1ede59e242460a1dd54df2395cf8c64606c4"
    sha256 cellar: :any_skip_relocation, ventura:        "022443f72887c4f251851f6fba1fa265b8e4955395ba8fa813bda7a4076ce815"
    sha256 cellar: :any_skip_relocation, monterey:       "b261a662309b5a625b5a2acbb5a23b5f707197c6d4b90947f181815b69a5fba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4885bcdc7eeabb7921fdc5a4be689cad3e449ebdffdbf9e17ea85e2a32c2271a"
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