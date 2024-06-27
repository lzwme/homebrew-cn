class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https:docs.camunda.iodocsapis-clientscli-clientindex"
  url "https:github.comcamundazeebearchiverefstags8.5.4.tar.gz"
  sha256 "9b035213dc14f00f9569163ee38cea9cfb8d36b9fbf850236d010dc4678267ea"
  license "Apache-2.0"
  head "https:github.comcamundazeebe.git", branch: "develop"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub. Upstream may not mark all unstable releases as
  # "pre-release", so we have to use the `GithubReleases` strategy until the
  # "latest" release is always a stable version.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50af1ee35c4744dcd7a422b40baa0987b89f1d7dd20c7ce990263f6c5af77708"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50af1ee35c4744dcd7a422b40baa0987b89f1d7dd20c7ce990263f6c5af77708"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50af1ee35c4744dcd7a422b40baa0987b89f1d7dd20c7ce990263f6c5af77708"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c6db8f2668b9f7a562c919bb89bb78789ca57ce25cbc85b39d8d85e4507b141"
    sha256 cellar: :any_skip_relocation, ventura:        "3c6db8f2668b9f7a562c919bb89bb78789ca57ce25cbc85b39d8d85e4507b141"
    sha256 cellar: :any_skip_relocation, monterey:       "3c6db8f2668b9f7a562c919bb89bb78789ca57ce25cbc85b39d8d85e4507b141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d5f765a8f7c68d25689da8387bfc9e3543e362f841a769fa1fe662b108577bf"
  end

  depends_on "go" => :build

  def install
    cd "clientsgocmdzbctl" do
      project = "github.comcamundazeebeclientsgov8cmdzbctlinternalcommands"
      ldflags = "-s -w -X #{project}.Version=#{version} -X #{project}.Commit=#{tap.user}"
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags:)

      generate_completions_from_executable(bin"zbctl", "completion")
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code = " \
      "Unavailable desc = connection error: " \
      "desc = \"transport: Error while dialing: dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}zbctl status 2>&1", 1)
    assert_match status_error_message, output

    assert_match version.to_s, shell_output("#{bin}zbctl version")
  end
end