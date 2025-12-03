class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.40.tar.gz"
  sha256 "1e02eba0b4920719bf8f53a3423c31ce2790055cf0256a65a134f6bbe978cd2f"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b1533efd43293e3990589ece7f3619c1af37a3966b26b692929d5bdf4e4c87e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e9a96695235a781492e4e3ea5a6d008c863e1344ad0a28751a2051e4726a157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5446cbdba159d26cc7bf0ad95486753a5379f293c877379783cf1f186e0f164e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eaaadbfa5956d4aa9d13dbacb13eb81c9f9a156668692f4f784c8c0dc112580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c470db51b9f04398cd4fe37987277e1c9b2a9eafbf46a3e02ef6a1a5129e314b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf90a7d703b7795ba223be23e3a6cb65145ce50ab608f62a76135d712484e667"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", "completion")
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