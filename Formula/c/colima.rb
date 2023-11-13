class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.0",
      revision: "088283a24237ccd6ef4f27f3e3040b48bd147a23"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4812a5f7194a37309b1409ee23041e1535c5f3fa9a6a10698e7c8f5a57094a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e412e68e441fa8c9a31532a287c821278a06d4726d0b1651048cf5b9ff8fe16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b9f777b432066d069a6b99cde8dd4b41242e22ece300176f08a2f1dc6a88359"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e92765dcfbe87fc9a173f1a5c782a9ce2f26de9e5ef949aceec8874a9bf21c5"
    sha256 cellar: :any_skip_relocation, ventura:        "becb195deb10b59a9724866901adfb2dfff733308d49d3fe08d60b9a09d3f945"
    sha256 cellar: :any_skip_relocation, monterey:       "3af4cda1e58c57b9ff8a57371cd3629e8a236c226e0053d493d9000461c680b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4666e7e24e349ccef27ce20e6b21a4606eb17bf471133aa5be479018444bd98"
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