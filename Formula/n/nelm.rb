class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "d50741eedb7a41619e962dcb1ceaf29452aceb133f81995140f9b87b7c92c348"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db9d1f87130dcddee744901ca1c9d09f3b61a601f2f75636b05f1aab484a7104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2aae6a6c932578810d8e15b6a24e3f0d8eb7db18bbd990cdadbc427cd3195c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22b325982d1df094c5524af5d6286641616f5a23be94ea7fed8fc325c033ea0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f8ad389c2f600746d20fd70d24727c0bc06f30bb1bbe7e0512581d78fe583f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ba7295d1c5ec545b915088fe297982663c09d050a119520ad7a858d6c3558a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c5960c1563ad343ac80ecba6a97cdafcc31409aa0b481b6b4ab5ebd7f04947"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end