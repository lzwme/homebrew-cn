class ChartReleaser < Formula
  desc "Hosting Helm Charts via GitHub Pages and Releases"
  homepage "https://github.com/helm/chart-releaser/"
  url "https://ghfast.top/https://github.com/helm/chart-releaser/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "454227be63cad9dd8449898ebb5649de165a32fdeb7fc8d96e3d2871f738ebe5"
  license "Apache-2.0"
  head "https://github.com/helm/chart-releaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2645a78a232b6d29271e985f39396bf806acd9370033a9e33936d28dff6e3a86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dad50acb064a88b70ec49faf32bc4f8bf8ce8f35e1e0507b1c4c464c5c505ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "343c287cf48bc35a092fba14907fbd295d58c68aea1326515fb5e6500cd36e72"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1995af325cf65b713788a07dcb2a0e99d3db893e514377723b112bdb304b3647"
    sha256 cellar: :any,                 x86_64_linux:      "b597bf36a3cabfcbe324f2db05569a39c43e48ff9495d4cd11f8324421b2a796"
  end

  depends_on "go" => :build
  depends_on "helm" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/helm/chart-releaser/cr/cmd.Version=#{version}
      -X github.com/helm/chart-releaser/cr/cmd.GitCommit=#{tap.user}
      -X github.com/helm/chart-releaser/cr/cmd.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cr"), "./cr"
    generate_completions_from_executable(bin/"cr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cr version")

    system "helm", "create", "testchart"
    system bin/"cr", "package", "--package-path", testpath/"packages", testpath/"testchart"
    assert_path_exists testpath/"packages/testchart-0.1.0.tgz"
  end
end