class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.16.0",
      revision: "f958638f15842de8fa423fe302f3a4eed45a1c61"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4930ab412b02e1a651f021029b8026ca440f8581c564fab09996def337372bfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b00003613c3980dd61a263116ff674cc3033837cf9ea103704b79ea36b0898f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e480a5c9ee7ae93ba51fd6305d93d05f6344c6f54eec7b1fab0db7b096d431d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7393717c5be6eddf3deb595bec26b05d227052c400e465a4fea558d77872c956"
    sha256 cellar: :any_skip_relocation, ventura:        "dbfb943d8bcb4ccb82d46f0bf545fe921bc7e6b59caa4033d46985587e9497f7"
    sha256 cellar: :any_skip_relocation, monterey:       "6597c24c5deff102f0993055f8ab921c5cda626b6538ff4550dac2f8f2760bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98cb98e5dae026d52b2811adc1f68139c7d9514607cbe8019290df8f9eb6e12f"
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