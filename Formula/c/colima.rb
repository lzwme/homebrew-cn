class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.6.1",
      revision: "fa1bc249f921287745f01fb02075c9ecbb491c31"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb9c59a5067bd444f322534257182a4a434b94119ff73e74402c4576303cd6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b306eb991ddc3435164c577a9fa46816636c3c39b779b25860536052faf977c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e9ef5e3ca4defd3be9141b7f2b7849b25146bac6cfdd0511141c70e8a7213a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "162a57aea4f4c7712b54d72f91f7ac5b71120a3bc6231b89e7ed92ba2626c2b4"
    sha256 cellar: :any_skip_relocation, ventura:        "0c8b4061781117effea87dc0bb45e53bc64aecffdbc01d659b8296a482262a54"
    sha256 cellar: :any_skip_relocation, monterey:       "536fe05405bdedaa64da614cb8a8fcc10317a5e80dccfefbcda2231139fdf6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83108856e39a1ba4bc19b8087ffd2b04f5181e1e49132b804f404cbec8ae600c"
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