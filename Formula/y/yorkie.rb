class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.12.tar.gz"
  sha256 "a64f379461290273a606b7e4cccafecff006f811741e339d35ef50bade22326c"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9afd04ba6b3052920f94145a9aa7e5389932c890e2e448be6f0dd2ff4138cb89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9afd04ba6b3052920f94145a9aa7e5389932c890e2e448be6f0dd2ff4138cb89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9afd04ba6b3052920f94145a9aa7e5389932c890e2e448be6f0dd2ff4138cb89"
    sha256 cellar: :any_skip_relocation, sonoma:        "617608a391d3c758f4f5e99f96a73fc7e4a16e752c3ded989bf3fd4989830673"
    sha256 cellar: :any_skip_relocation, ventura:       "617608a391d3c758f4f5e99f96a73fc7e4a16e752c3ded989bf3fd4989830673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09fe7f235e5e333c6d3f4925cb6444b8ef01b5eca6915c73ee36a86ada4195f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comyorkie-teamyorkieinternalversion.Version=#{version}
      -X github.comyorkie-teamyorkieinternalversion.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdyorkie"

    generate_completions_from_executable(bin"yorkie", "completion")
  end

  service do
    run opt_bin"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin"yorkie", "server"
    # sleep to let yorkie get ready
    sleep 3
    system bin"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end