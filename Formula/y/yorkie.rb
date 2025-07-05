class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.18.tar.gz"
  sha256 "e0e0bf628978c49b3da0e6d48870c0115cf1b23dc37382bd61aed88002f7a117"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75aedba6bbaa80952fd7675a23670a581fb8159a69088a852b75ba0f17586b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8a1ccbb1b6273540708a6f27684d087e3e31e542c0720c834704611d9aa76f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "639b22f0c663db0eaae6638c65d44f766de2945ecc78c2480ec6b9d762a5809c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b337b7329ad0ec83df5a8c4bcdd133c7d44bd90af724b474aab80bc749ec1c54"
    sha256 cellar: :any_skip_relocation, ventura:       "7f141ec776e4e0ee9f32803403c7d194724d5271f9310f775aba400739b108aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dae926c9fdb2ab5c234d8bc9dadbc5605ecfabf83733e85f7e6f6b53e557e9ab"
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