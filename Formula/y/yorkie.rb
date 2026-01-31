class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.46.tar.gz"
  sha256 "617edae4f4a3b4b323debef69387c12f7114017e0ae0ac79bc07be83c436a4d2"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "887551c49de92d5606d8608f5bee505f808a39a298f11c00dff7d773a56ffd46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed256a9f71ff2e8dfa6852988722a782d745ecbb28dba41fed2276a8d5b04d30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5cabf80f906014ebf940d1c905e5fe3accba2170193ff872b03d77f295d4e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0ef56abf86ba5c177c621eac79ea68379f8648224c6dfd9e3f9743bbe868652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "827731cc3f66ab9b17a05944958be89430a0715852e5f5825d98fb5f78812360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a97e17330ed14374e77bff60700f1e99e96e6c66771abef34b027a44a31ac2c"
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