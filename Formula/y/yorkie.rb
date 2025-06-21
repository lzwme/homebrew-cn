class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.16.tar.gz"
  sha256 "3dc132a70d6cb673169597798f67b54f360797cdb5d353fcc3baf7acb195cb36"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08f609c64faa1ea08365b77f6338e2261c2962fafc1e94eeeb7d91d25f9371c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bad3f7fb3d4dfe2d3987cd25d7a36babde56109fcd25a45a66efde94cb38fdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af88fbaa23b9f5450233e0538c95a215de548e1a983964358de2cdc15f69d482"
    sha256 cellar: :any_skip_relocation, sonoma:        "931adf0e6be53e0a3915544013a14aac7fb2ea86bb3ce89d3db7d913dcb99e1b"
    sha256 cellar: :any_skip_relocation, ventura:       "d4af1d061e9fe44dee0b6c8e604a010228255944626454b369bd081a2aed32eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2f68bd0d6082ff8fd9b61423ff6f0295bcc7381b564f880b7fd88a62eef709"
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