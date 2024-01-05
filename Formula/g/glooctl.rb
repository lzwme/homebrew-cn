class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.15.19",
      revision: "99adfc51f18359c0fa349f816aef3dfadf6b11b6"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f18ce6771f734e88aab90325c3b16d0c2f0fe06692246ad4933ba6fbe385385c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a34479a2bf052b27ca493ac157d3a22ddcbc685f338e1222dc63787f9989ffe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f34882c184edf393b3ae788729f3b33bf5e935a87a8ed4f4a5d42efe03611cd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9dfdf34a53bfcd729e1cd83a4502e157907443bfda4289dda934e9a84f0e9f49"
    sha256 cellar: :any_skip_relocation, ventura:        "4d20e081181de7b0db021c5dffe4c014ba08b81871b4d58c9d9549c2d1756279"
    sha256 cellar: :any_skip_relocation, monterey:       "2b2bbb6f550e81637e62bd66e710be4c264e58187e6eb7d56beec69db9aeb8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "094ed5535b8192ba97c8f9e57ebbc446ba22f8bc31338b73527c973dde068371"
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
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end