class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.20.tar.gz"
  sha256 "66aab86f3c10c93fdad6a936efb2ce76db8dc20936c0cb7070da7b3b3a029f12"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3830b25dbe191812ed89ecc68ae14eb7835d25db41b53756ec763a3d3424ff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f081b380a206ae902ba1fc6daa06bbd48899a1e150c4d399e440d3c5c441fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd3e47c1071e5524f9386abf8a404bb8ce1d9db4d7286892edcbae142f29736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d893378ef592beed8929b7a8954081c073402c3d6650b6f738f6907345878ff1"
    sha256 cellar: :any,                 x86_64_linux:  "5f6f5ae320239cb15608853cd1e00a514cab4c90b11723f1ce55331c5dc4971d"
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