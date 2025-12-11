class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "11f84032ea4f2ea3a9fe85e92486a1c11dd6745052e2b57cfaaeabb8460f7823"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c68c88779a3e5227a70e8bc0a95255a4e54a836702b6bf5570b2ea698b59b758"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee69bdb5694e9ae4d7980e0a7290f22d5a5fdc74c5a963dc8f9e336e40b47450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7f127548b894f170f426121d5d2db38f1bc5d63e68a5f2d37c02d9733dcf03d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d50cdd83779a8cc24f1e0fe8da3556260e43c1848344260b7f44a1124e97a4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb2268c32d55e65ae0bced36fbc63204afe022616eaa64d603ed86dd587e143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ee2fd99e030227752b2173a19afc2825bccbed33b951208d9b52e721c83cea"
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