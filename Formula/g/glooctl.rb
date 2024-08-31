class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.7",
      revision: "5470ada2198386502332a508662d97dde3eefbdf"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a202e60cbad1ea308157725d06951458eb77a8151e68d93d1d10a0b523acbba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b4ab87cefddad64e768d30b8f5dd3264c08882181926bf92c124d4276765aee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bcf2a9b6365adbf4ce056915718dad7002f40330815e5306572336ce8839bd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a725789625f053573f4839b2d25a5f22f7606282cabd363c0156359299fcf603"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c897cc484dc7ad5c8f01c0debddbebac5cbf4a72675df53cef1aa6d4726678"
    sha256 cellar: :any_skip_relocation, monterey:       "b204cf1af8cf2ffaf54e05c2ea044513ce57cb1d33250f40b0f8914cdb67a55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369a1892e6fb332c5fe320d88945df0ce9b7dfb2ad8f1a03afcf2d1dc504c772"
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