class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.23.tar.gz"
  sha256 "0da8c83633a52d5f6beafec98fa1087f02bf1da89eef5319cad71c5ea628bc35"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d18ab5b8af62489c54f1601eca1ea2cf822fe36fee24a4992c79160dbad5bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5b59af409e4f7c8ab6af266108e19746106a24159efb465451aa281e16bc0bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ff281ed20b133b9889e8d1c4a527572eff229456bdee3311a15ca6a581b818f"
    sha256 cellar: :any_skip_relocation, sonoma:        "05f641c3c039f3c18c1014f81908561ca6bc6440d4dc4736bc4381e24b107de8"
    sha256 cellar: :any_skip_relocation, ventura:       "d8ade777030399dced97dc8cbe680b126f5268d986b8523f3d2c34e2028943a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0085187522761ff653f24cf92511554480fde231cc31096a7f13498674475cab"
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