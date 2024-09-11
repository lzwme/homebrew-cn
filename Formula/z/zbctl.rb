class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https:docs.camunda.iodocsapis-clientscli-clientindex"
  url "https:github.comcamundazeebearchiverefstags8.5.7.tar.gz"
  sha256 "81793ee00e7f78a87254df6cab9884d35c13d2c6ec508a348e6d983a1f99d381"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "55bb7d2386bf2c021bce092e0959e7037f1796e20396d9a77e5f5f71a0d5690d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55bb7d2386bf2c021bce092e0959e7037f1796e20396d9a77e5f5f71a0d5690d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55bb7d2386bf2c021bce092e0959e7037f1796e20396d9a77e5f5f71a0d5690d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55bb7d2386bf2c021bce092e0959e7037f1796e20396d9a77e5f5f71a0d5690d"
    sha256 cellar: :any_skip_relocation, sonoma:         "97df121911959d73cb3d7850e5b2345047683e2476e0874a914dedfe0b214ebe"
    sha256 cellar: :any_skip_relocation, ventura:        "97df121911959d73cb3d7850e5b2345047683e2476e0874a914dedfe0b214ebe"
    sha256 cellar: :any_skip_relocation, monterey:       "97df121911959d73cb3d7850e5b2345047683e2476e0874a914dedfe0b214ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "005eba8d48369e0e90a25502dd9cad62b15479805a97a1fbe62b55441356f7fe"
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