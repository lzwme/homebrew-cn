class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https:yorkie.dev"
  url "https:github.comyorkie-teamyorkiearchiverefstagsv0.5.2.tar.gz"
  sha256 "958ea80094ef17993f3c71082f671a27576d4ec306e9f52f3018488b0506b3f7"
  license "Apache-2.0"
  head "https:github.comyorkie-teamyorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78f603168b9d9b2f3d3b25dfcdc27fdc7bb68da4f5c6803cc7c2f8f639204ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c78f603168b9d9b2f3d3b25dfcdc27fdc7bb68da4f5c6803cc7c2f8f639204ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c78f603168b9d9b2f3d3b25dfcdc27fdc7bb68da4f5c6803cc7c2f8f639204ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "66b65ee10b68cc3ef8b9c2edcb43607fe544d2b92d25184ce87a1423bd695989"
    sha256 cellar: :any_skip_relocation, ventura:       "66b65ee10b68cc3ef8b9c2edcb43607fe544d2b92d25184ce87a1423bd695989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5476a2a38ee01c2060c707d8119bb58e75d13d71b65dfef9c7731d09ca76d4"
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