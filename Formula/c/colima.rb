class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://colima.run"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.10.2",
      revision: "1afe7c4771501eaae2dc1cbe506c4a67609ed151"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26bb71917e2fee7cc8673f441d3e022dccf3f85a150b10b234a8ef6e49810806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01b6ef5ead03112e93da7794f30612d92252c46827c5ecffbbbd66aba5fe2599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e266f985d9e61ff71695d5c5a35d59bdf468497e1c5dbc1fcfbbcba852e8f6c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7045a74d38b5f0f02d1f42034e425a9d1795b6a12e5b371a1d99e323696d6b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f5d6bd6c0cf519d0f32c96318be9a1815bcb915a2717287dfb0fb0dadc5577e"
    sha256 cellar: :any,                 x86_64_linux:  "65414ffb494d8fe9cf1ebbffe48f5c06c114adf1a8323619ff6c49d28e007fef"
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

    generate_completions_from_executable(bin/"colima", shell_parameter_format: :cobra)
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