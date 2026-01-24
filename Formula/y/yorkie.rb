class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.45.tar.gz"
  sha256 "3ca4ba1d8de165e296b7bde452ac3ae737052e4d8018e47fd21c24796a3a4705"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce88b53237cd00df871a6474d6b6e28e3a22cacc7bd9254a15468f73a9c33741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f68eaa787e1332f4b6c7b32df37ac2e6b4631046bac0a1d5993fab63ac64430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c598288eaeca7033a887ec2e51ba27243bebfd0871878431c9cd98711d1898d"
    sha256 cellar: :any_skip_relocation, sonoma:        "08b90f015aac0b90452270efbc0946277edbaacc215ee9af3f6fe3dcb0b1aba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fcc6f3802ef637318e232d5390eca914d3741a0050a9d02d6f6cfc2b0e6f7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cdc0ef11d96ecdcecb2c3872bcf1384ab0c37f9a70f56c92fe35fd75481220b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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