class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.3",
      revision: "5e16aa5bbd8891842d9c941448dd1cb491dc7e5c"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edd0bc1bef370803b0def6b658132632b2990885c1cbfb2d1048b943a7d1c169"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c16e5a7bad734187ce2d3cfd7d65232616955391b913ba9799337c581b78c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e20418eeb935d50a86d42361fe48910fcf9b3ac607e99980cafeaf2995bc8cca"
    sha256 cellar: :any_skip_relocation, sonoma:         "c00464bb1701b7736cfac88e7e2376c8d74632ac019dd8df34064d27b745b625"
    sha256 cellar: :any_skip_relocation, ventura:        "f278a32455cc73d9e6c4146a6f5b6d92153f6f4a6ab5ed9339581d4b87bd77d2"
    sha256 cellar: :any_skip_relocation, monterey:       "c59850ab1c208f616c0f4d9cfbad7c15ba93238f704e0f41b6d7301826807dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43ff0d49a5d25bc2ff883ea00e7e86371d90b877aa6817271f2c44f053e30cb4"
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