class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.15.tar.gz"
  sha256 "5ac95596896a4e3c9e71e7428e3bd38814e536a7eb8b3b5a54141edb26955689"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98d76685880a52c6c392f7a4e86609a910df134029604274262e4615d7b0dea4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0469b781bd532ce4d63971272fc466811fa70343f678d5871c79305b749a75cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb5cb47bce34abd6a5b2bf0bd0ece5ffa013eddc3d959963087ed5ef4ada254f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c31ae3ea3b403cef062d156e7ef126f4aeafbdf68387cc9982b1501900d46fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cebc9292a3115e3af1dee4578e09a55b38991ae7ef92ea655ea30afb30066e55"
    sha256 cellar: :any,                 x86_64_linux:  "621b7a49fbf7a2c492fbd81c5203fded7133b9d07e071a20da3391d0b1021266"
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