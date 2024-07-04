class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https:docs.camunda.iodocsapis-clientscli-clientindex"
  url "https:github.comcamundazeebearchiverefstags8.5.5.tar.gz"
  sha256 "50d8ac1dd0447d7cd0b4e73ba9ddcbd176af1e23702d201918bd5826c25a79cb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18f5ab10d8b0c674d0073a31b2cf2d1cfb7baaf399b9dda30d07bd7997a8118b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18f5ab10d8b0c674d0073a31b2cf2d1cfb7baaf399b9dda30d07bd7997a8118b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18f5ab10d8b0c674d0073a31b2cf2d1cfb7baaf399b9dda30d07bd7997a8118b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9e078184d270b89e4728f63702a7b1a33575a03468a1639d52438991c791746"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e078184d270b89e4728f63702a7b1a33575a03468a1639d52438991c791746"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e078184d270b89e4728f63702a7b1a33575a03468a1639d52438991c791746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cdcef9a1b0b160e4cc8990114cb8c20202a5419eae96aee0280eaca356491aa"
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