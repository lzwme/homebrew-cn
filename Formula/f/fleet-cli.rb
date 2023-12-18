class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https:github.comrancherfleet"
  url "https:github.comrancherfleet.git",
      tag:      "v0.9.0",
      revision: "93432f288e79f436e2f5cfe940e3274994d00b29"
  license "Apache-2.0"
  head "https:github.comrancherfleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9657a18ca999f81b6c902528222f26a4f22328672a104536ce6028c57b6f15c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a211ae7f1ad1d880844e3bcae764f650e296b0b3bf0a9fb9ab61d6a661a00f59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0486314fde97e9b22743d3a122182679bf68c25cf74408a81f797c5d69bb67f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4f57bd6d72645dbee0d3def1756969077f93ac778e36f3d610e9c05a4db4d14"
    sha256 cellar: :any_skip_relocation, ventura:        "078e3acf55f6a08704505ce1c8f7a02f4697470a6d8acb6f34e26f5265ca3430"
    sha256 cellar: :any_skip_relocation, monterey:       "8b20a55dac756e2ee9c4a8a9799109973d547991ce381aea67d6292b9a5f501d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53bade2815a79023ee962de58abfe81920aa3025fb09829377b50b5e9d53546e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.comrancherfleetpkgversion.Version=#{version}
      -X github.comrancherfleetpkgversion.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin"fleet", ldflags: ldflags), ".cmdfleetcli"

    generate_completions_from_executable(bin"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https:github.comrancherfleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}fleet test fleet-examplessimple 2>&1")
  end
end