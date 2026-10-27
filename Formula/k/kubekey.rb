class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.8",
      revision: "f6b1019891844091ddb14580a8d3aeb3251c02fe"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd1968df17472610c2a7e8226db599342b1fc051b8ac5c3928324dee55d13e25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "343cd733d2a5bb8c12686056bb829c675dfa89c6cff47717d654c2f87838a2c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cafba082b650f420bbd6f0129e94eb7f8e480a46059a17aaaf24444e193dc8c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "18829b737522d626dac23cbb3272fe98f16a663e6c1967fe7170de134ea90f99"
    sha256 cellar: :any,                 x86_64_linux:      "2da114bb72117c0a817f25d889ce75bedc7c0689a992a76302340731f489bee0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    project = "github.com/kubesphere/kubekey/v#{version.major}"
    ldflags = %W[
      -X #{project}/version.gitMajor=#{version.major}
      -X #{project}/version.gitMinor=#{version.minor}
      -X #{project}/version.gitVersion=v#{version}
      -X #{project}/version.gitCommit=#{Utils.git_head}
      -X #{project}/version.gitTreeState=clean
      -X #{project}/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "builtin", output: bin/"kk"), "./cmd/kk"

    generate_completions_from_executable(bin/"kk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kk version 2>&1")
    assert_match "apiVersion: kubekey.kubesphere.io/v1", shell_output("#{bin}/kk create config")
  end
end