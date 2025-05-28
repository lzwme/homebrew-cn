class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.13.tar.gz"
  sha256 "5f58a0b531950ffe40e8722e893bb40513697f558bb897d6ab350a33015f029a"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76e26a0b39958b2538d3c11f3831826151a49acc1908d747c3378c25b54ca5b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76e26a0b39958b2538d3c11f3831826151a49acc1908d747c3378c25b54ca5b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76e26a0b39958b2538d3c11f3831826151a49acc1908d747c3378c25b54ca5b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6940f9b40b763b40fc5774136ba32e80a2540491d96d6596826b168d1a5cd3da"
    sha256 cellar: :any_skip_relocation, ventura:       "6940f9b40b763b40fc5774136ba32e80a2540491d96d6596826b168d1a5cd3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d9331cb9f21bb052c7ed97f10e0abe39efa57ef1e8442b5e36598c968a8b8e"
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