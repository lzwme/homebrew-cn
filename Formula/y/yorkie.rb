class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.47.tar.gz"
  sha256 "642359a486c4f19755b19202e939018bf7ca37eab71160b193a3908a7292e875"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbd4057abc3c81658fcb89506b78ba1a611fa326c49eb53c46e47265acbe95ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c14cc291eaf4ebe4267adce92029a24f1d7e19f5759f7edd51eca2272a64402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84180ee5ae1c59cd5181fb0c75e7da0dea1efdf21f089f4a0d2c720e06d046f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf499fc5441b29c29f4cbe29848aefc5cc312864f719940e8b41b866f0ad5a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "604fc13ab927559e88bc46e346c69b5c51b8fcf6dc7792ccd796d3ab42897ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31440cec2b454b291ed4b8e939afb56b6803798ab5901bff443867960da9ac34"
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