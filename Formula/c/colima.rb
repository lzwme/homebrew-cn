class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.8.2",
      revision: "798f8ef9a3a9b6b641687027988f2cd4ea2c2f92"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bea7e4433dddb3fea51df728f6a5db82ba095e2921ba8fd24807484b707b508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d306bf302f7c85ce46b0724ec7fd77937f3cc979ae5ead4b5824e6e31ca1c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a54c7413ef753eaf2fe2bc4c34bc8a3db3ad5d6d70ee81ba977408dba2231f53"
    sha256 cellar: :any_skip_relocation, sonoma:        "38b1868b7a532b20039c7bae1baeb2247ebddacde943ca545a435f786ea99752"
    sha256 cellar: :any_skip_relocation, ventura:       "f00f90d0b1a0713ebf41c0b23232d90ef275c8a6d931319b26d2ec33fc8748ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac1dfba8d79cd766ef7a6607631e9175ab6818959318f29a1563ae0eeaaf617c"
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