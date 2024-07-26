class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.4.28.tar.gz"
  sha256 "1c4ec1641567ec215891accf6f988fa5096e49fcae2787b0f45e0051fbbc4151"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b12b41dd3a81977fe06c8c6a05179488e651fff262ef213d6ce512dc1dc82454"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b30288d994d4451f891a944eb79c14b96aee8e1fd51e73f17afc4f58a0c20987"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c750a533f35b9b34e2f548f5c0dd5ebbb00363bc0d0ad27d5e04bbe056d46715"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c913bb269e2069c3527e08e65f4a3bbade6018ea031ee61a1d848c642ce092e"
    sha256 cellar: :any_skip_relocation, ventura:        "327f8323d4070497c64957f94499747a35155b178db7d0fc8459d6e23c3e5a95"
    sha256 cellar: :any_skip_relocation, monterey:       "f480dfa1cdf98255c4e3335779f63d633ee05f4adb73cca37120ee8c834d34e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeb736af772f79c3094a8f8484bd292322192dd45ed42f8753b3299b7d743e95"
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