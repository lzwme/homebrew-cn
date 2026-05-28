class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "63ed1b3b89dc3e28d7ed8f7895230b4cf84ea4fe78a6c31f17dcf3c21c2e3807"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba73a434c74b45d8e539489ceb6abf0b5e8fa2df2f8c489522be465808676cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e09deeca5737cf69e1fd3aad90f0787bf1ba58dd3e44d36424272c1c00fa8ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b024bcf86921adfacef272e775d7ea3f7669a7676ad40a42964074b9abbb9449"
    sha256 cellar: :any_skip_relocation, sonoma:        "f20ea1e62747e4ce9fc67ec1a3f3e0be728e2d0507ef883728c3865ce1868f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddb7bc32fdf669f05d7d65ed568404fb939586376040a09e5278d75256e974a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e33d4c5c4958cb0595bf13da1196ab72be4dce2066f3e00ea5f4b4f04a570fb"
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