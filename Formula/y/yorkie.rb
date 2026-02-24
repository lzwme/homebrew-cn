class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.49.tar.gz"
  sha256 "dfd4af574c59409d24276bdb1a40c9a3b412161a29271897f53fc7418f0dfc3e"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9535ade35d1baa9faee05b662a73f7e004b308702503410c9491504c39db192b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3a29df5546397701df514a705eb3034cf37800340ba75d8204fb05022581204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b5ab1df3769bff4ddd74f6a313f2a1eb02bbcb09cd53519cba3725ed04d346"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecfb574f6c86e2dc21486a395869553fed001737cbb6ab0542e2f38b01f337f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06d481d89a9d48371c2f89c30cb738b11c661276fdb3662b2ca9da7b73204f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd0ae776f853400fd86b7b8318fb18cce8d10dcd6e00e13cd6c74321b039520"
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