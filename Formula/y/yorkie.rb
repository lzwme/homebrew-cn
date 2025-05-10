class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.10.tar.gz"
  sha256 "cc9b9207f681c8655bec58fb17c1de652a72dd2ecede14558dccb07f5c57fde7"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b679e675bafb2d517f91eb5fae47ecc37d0f748b377ad3b38c1d56c965e3ce1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b679e675bafb2d517f91eb5fae47ecc37d0f748b377ad3b38c1d56c965e3ce1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b679e675bafb2d517f91eb5fae47ecc37d0f748b377ad3b38c1d56c965e3ce1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab6a4127143ba211b91f2d989b2b98be246c439646f23b739abce8fe3bf6a4b"
    sha256 cellar: :any_skip_relocation, ventura:       "cab6a4127143ba211b91f2d989b2b98be246c439646f23b739abce8fe3bf6a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba338f9b06a6477d68f8308dee0ad25e45b6d176e48676a55292bce5a05dde18"
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