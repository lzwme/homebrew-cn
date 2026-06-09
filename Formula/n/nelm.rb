class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "a95ef58ec1b6f11657eb5dbeda737fbf5f8c1e4c2c801bc1726cbcb4d55eb98e"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cfb5bee098171303547b6c38dc8cdd69f9750d8628808b63c7313b5a1612eaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d33627c6f9de2f1b79bcd7a9fc3a1674a618ac31f1c6797afb6b406805d2c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c753439707be81a3ad73aa26fa47312f33f378d44c65bada366b3fdae1bff357"
    sha256 cellar: :any_skip_relocation, sonoma:        "234d28a3888f91f4a304436e5684d35f4e41f4694727609de0603a19d7878618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "228ea846a4a4bfebeebd6f20e5e8c227f634965b0a51600ecaf4eea8f9849940"
    sha256 cellar: :any,                 x86_64_linux:  "40610c5dcc2b954e666e748d476a387aa5b762c0cd43b211d22b24356ed4c402"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", shell_parameter_format: :cobra)
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