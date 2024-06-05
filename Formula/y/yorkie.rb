class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.22.tar.gz"
  sha256 "4f93e871b086869397e654c6bfae178e402c664332a583c748cedfd8db7a1eb1"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e564b0e0f32a96396047a0fd4028728791c4513bd83d027f792d94e51f8b88d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5469a708c092502f5d4096478ea9532f31975549701c178560d9e2141989a1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b608361166c637edd4e40ebca3836eb5d612021cafaeea74bbe3283284b9086"
    sha256 cellar: :any_skip_relocation, sonoma:         "3216206fc5fc9986f469cd782569a33b5d87792eb778fb80507ae8a7225d1cf9"
    sha256 cellar: :any_skip_relocation, ventura:        "8befdd822309334def7363a96a66fe57b2c8d68da2fe02ce981247e8df82c8e8"
    sha256 cellar: :any_skip_relocation, monterey:       "2b5cdee9e27d644f2c65fd4746e75ce9f5badfeb812246dc38992329419802f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de4513a1a0d7a7a19d123b365e8658fafa25a223ed8b5b241b568eee15c40fe"
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
    yorkie_pid = fork do
      exec bin"yorkie", "server"
    end
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