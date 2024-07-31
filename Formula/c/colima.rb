class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https:github.comabiosoftcolimablobmainREADME.md"
  url "https:github.comabiosoftcolima.git",
      tag:      "v0.7.0",
      revision: "4b14e8a9993b17d2e6f5071fd9059513111cd365"
  license "MIT"
  head "https:github.comabiosoftcolima.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "544301a8aaa3ae8fcde297448ae0f5699820b711cc81f7d83a37d6f97d7d1bd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6b09b6333769f1007fde820cc1b2f8337669baa84681a3f33da0d053a4e4c35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79b155558880ee7357c853c76612b5bf755f0069f89999a15282cf70d07f787"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef87ef0d84f9412dd54f8577cb796d5c883e0696658703ce207d1b66a27c7b1"
    sha256 cellar: :any_skip_relocation, ventura:        "aa9da61d9beebcfbafeda24b232e2a9ad716c187f3ea8a68d1e8611ef5150f13"
    sha256 cellar: :any_skip_relocation, monterey:       "bd4fb23b73f083fb5d356090eddc065dce14afbe332017e67f7b7f2dae40b79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7413c579f7f35d685cd5223c62c0e272a45c2279f67fd0c19ad7322ddccbbed"
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