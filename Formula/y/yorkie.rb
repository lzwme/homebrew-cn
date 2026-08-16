class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.16.tar.gz"
  sha256 "87d596ea1179109fa80cd12ad7d0ce615922d156f28c668a6dbae4bb576784d4"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddf75b4efa00face21aa352e8280d5891d469f7bb7906d9cb6e7ecfea3532b10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01c8d59e1b42c49d261ad0410090c584b16dc7cdd34f1fc4de47de9979fda9e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0183b08da356c9f8759cdd72b6dbec7bd42b018142b1e57d4ebe1b987ce3ea3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bec339cd3d54e9be09796dc05fb5e2d5a94b8a6a631f9de05f105759f3aa3b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd802724f9cbf0cb7951333c30f6dddd2fb98ee6a34972324ac2bc3bf314f4d6"
    sha256 cellar: :any,                 x86_64_linux:  "ef60e69426b2e1f15229babc0ca1b9e9cb32fb9a515032dbe20eab668d873bc5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin/"yorkie", "server"
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end