class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.1",
      revision: "b167435c4d42054bc79cc6b85def95f86140b861"

  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a18db23cdff5f5f8659e5f8be9a8b956967bf41d5f67fd417e369f9ce8ec8cb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acdcf6fa6289771fcad91e5a82701dae771cf4fec35539f81b0a23e63707e69c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "617db9e55206ffcf97ff2a73e7fac2e4cd30df980073b1f00ef61d620dd0b124"
    sha256 cellar: :any_skip_relocation, sonoma:        "bedd84b26f2a4cfda2f2b77b4470de37eaa6e734085a57f3d222c1a8823d473c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9edac4bfd1160db1c6b5f8f1576c05cc89ffb83bdb2a1a7315d8cbf9ca5940d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5faf097fcd27d27c8ff70d335993d074fc154434503bce101a349a40e0009b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra,
                                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    manifest = "https://ghfast.top/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end