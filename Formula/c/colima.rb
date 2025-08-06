class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.8.3",
      revision: "6a6da99761f300110dfde5ecc789afa35941c3ac"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e21a5a958e32bf0254ad87604dd75ed95abf759741d403299bdbd7fbd3944702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a7c4fbf95ef04d87ba83b3abb20a588235788fda7618a4a4bc752e799bc50da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99f8e5ee475626abcb3137f3f7cee719310aaeae1878126fad987f85c7045e98"
    sha256 cellar: :any_skip_relocation, sonoma:        "f42193f61daa374ffcd72cda1b9b95429b8655458af87465f005e070624b30fa"
    sha256 cellar: :any_skip_relocation, ventura:       "df83ccc2c86e37c6a4d5c37de36c401d0c03568bc6c4750dd1b1bfe56d783fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ad84bc06e899e4ae94982010f7f2793931935f07e71d98e07d1faa1f909707"
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