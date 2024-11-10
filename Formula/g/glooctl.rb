class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.16",
      revision: "051b0ca4b33a39b7b7cdf4cf6d3cdb4bab32e50b"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e204cfc01357f81b24191de8a358c26902e4b235e8a85dd2372010233a485078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7374cd83a6c41fa0edcd790c0e0e8c33ae86601c1b332c58dc8bb94b60ac88d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21229d64868039322628e41f65234394fb909e486d882a81ab822121dc7b0ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef17331bc8b89528cf0c42987b15e319073b58861f7b9a86c258a38a2fce6fbc"
    sha256 cellar: :any_skip_relocation, ventura:       "77528067ac084551f365cc6424fe379ae1c33e1145506e44f68178a3d27c420c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f068b0e5eddefd332907b75447d8b4cb5ac356edc547e323f000598be6cb429"
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