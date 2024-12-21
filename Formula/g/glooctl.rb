class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.18.2",
      revision: "0525c821103ab6a9749b0b9a03a184d727aced9c"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63e81cafeb65b320018c4c5dff8743ebfac32d43dfcae0982aa2a4460ccff59d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ff4259b813ba8c0686ac89b045bc51c79030a0e00a1274812e4eec5f8d3a9d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72fdce08999571e493fd1e42f615562c93c9f3252a7dc674961fe5653f40a2f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "290f7a08ab346de6ea17a999deb4d07b64938ab7e8a41edebf0a00019cf716db"
    sha256 cellar: :any_skip_relocation, ventura:       "770b9d4068096c4659c4dc85fada3d675185eeb1d5c809ad426730c2d0650be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5b1de242695cbfb0818a70e2cc17e0dcd2c2e675cdb2ded61efc40b3081383"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_outputglooctl"

    generate_completions_from_executable(bin"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}glooctl version 2>&1")
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end