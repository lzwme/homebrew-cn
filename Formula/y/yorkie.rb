class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.26.tar.gz"
  sha256 "7d8d79f2537550ef12671e5d7ec1a44b494963ce3ab7f474f20c240ab5cf8a3b"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a88b34d1f8c71c210bc8b9eaf70308ab2b9c14a2753ea9ee4f290575127d3ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce7caa8ea9e9f0aa508fc8f0a6ab1b25e5b78d2af1df5e35d73b9198056c0c3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5245a93cde513f71d0326c2242dea0581f49885f2e6d340ce66dc67b5191ca6"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8c4072d5437d4b750007668a3898242606f2ac5538945e8eafae8d597595368"
    sha256 cellar: :any_skip_relocation, ventura:        "0e5b2db6b86bb35c8eacbc3f871464b7eebf88c4f96796d3d5fc395bcdcfe77b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d49873cc4cd77d863d0d174b03396645b6248a06711afe4491830b7b6b9ac0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7857394483eac502819775109eacc72cb0f4b6f3cc0c99d2d2b8c373c4802ac"
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