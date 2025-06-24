class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.6.17.tar.gz"
  sha256 "2c2e701c960933d8a791f06fe474b6b93f36047ee00718b7f24c98c091debf27"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb48b6eb728cc20d60cc6f35a5922e2f0c60447c5c6c0c123ee6b130e2b6635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d92d06b1409ccd708224068ab5b2f5263d755085a0934d00af2356205a218c05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe31ea8d6429ac4fe9c765a6f7a5946df40fc6ee69188fc8c62088492b1bcb38"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c1b1e3af9b3d58aadbceecca86f1a64bbb5a100ee6a4592902c9d0e295cedcc"
    sha256 cellar: :any_skip_relocation, ventura:       "bbf2aa20bded4102f175a56a2580d044ece1a81e5b20da15c27c59648f0fe1e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea1803a05e77798693ef246255a53d21f3ad3d084041fd2a6e51bf101c92cf2"
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