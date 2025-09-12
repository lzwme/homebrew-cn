class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://ghfast.top/https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.30.tar.gz"
  sha256 "c1242388a0a86b215ba6d06597936ece6d799e3d21304f47d2e7a0d1015a7119"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "962fcf535e6001fb6eae6a9421549ee57cd2aab9092b9a2b8c10d576371fd35b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f52f7af42be0ed66519c666826659bcd7eb9eb890cf5a95d195d2a73a4048e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "331a39a3adc92d4214a8c7851545c013b23d81fbe2b73a5d67888a1769781aee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "156e892f71e98a108debdccc48602cdff48e7c8423454f995eb513ed5c79c94c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a30ebce43c8c77545aee14561cac310541f5cea5fec7927ce8167d089fb048"
    sha256 cellar: :any_skip_relocation, ventura:       "0b280046392290a5f130c2aa0b2eb220352d6ae8000660509ee2064ee16b1870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "284662ba96cb234f72edbc638f7b61cd2a140dc9e0169a94441018b7c2295561"
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