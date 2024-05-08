class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.16.12",
      revision: "ffeeac2b9d72e3a5fc907b673c93dc3ebbd1ae6a"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b70870834548e6e00cb9040c4a4870ca26645713102e60d6f68b013c3ce6b48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa33fff91b8a4b1b867333fe98643f2bd45e6cfb37b46307a2147e9bdda8f465"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74815c0fc84ab55d4865efe361d5e594ceb03e0b624e5516a81f091809b2d338"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dc80b4c6c762c549921a0daf284a747765b29d51ff2d6f1c1b96ebb8c1fef96"
    sha256 cellar: :any_skip_relocation, ventura:        "f7f71cb7d560ed8b1e9955feee3c59ef77e8bdf9bffdd739f2f513c24e4c05fe"
    sha256 cellar: :any_skip_relocation, monterey:       "97d3d015843df6f977d88df0df5859f1f6cc3c0edaddfb8193f6faa1e4c5c659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "706d3a04c2c675f975d996c22539144a0e58a120b61160979b237f3a4f83457c"
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