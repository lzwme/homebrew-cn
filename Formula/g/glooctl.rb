class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.0",
      revision: "751e637199edce4affafe8b040e73a5a02156fab"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c10a19da2e6f805afd831def53a97b31ed48f2598079f7415f8080e1aeb393c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bca77783eaf8382a1142e66e0862685534cd2d0cf088e4f016e147785701468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204729d2b8fa5460d98149759983ce7dc8a466a42f45598d9679c5d607803972"
    sha256 cellar: :any_skip_relocation, sonoma:         "70a53b00949cda3214816982b1faccd7dfddf7d547720eda35d4bdf8806b583e"
    sha256 cellar: :any_skip_relocation, ventura:        "b63ccd823935fe0cf30694f858a1091443c6ad16b773fc72e7941bd2a82544de"
    sha256 cellar: :any_skip_relocation, monterey:       "844dddada98b9758f8678ba4965f4e6ff67ace8eac97b99e42ba06f2a0bd5429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc80acf03b24406e683f5e3e00b09ae679b047a2a2a34526ecbe30b3db0a7e4"
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