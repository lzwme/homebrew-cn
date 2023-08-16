class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "37c7f9ef154e6969b3444c2170cfa339a5adfc02cc0d8ecf0b83662adb96bd18"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de6206b352327663f6e80d50c3f72fa7dc36317b0a0cdfe054e20dc410282da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3077ec5acf0b2bf8c7e6f029ad6d1fce11ff9f023162ba165e4eaca09dadbec2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2962f443e3f7e50ea2f5f48a3339f0f811984093d1f458e7c23095a6004a5b5e"
    sha256 cellar: :any_skip_relocation, ventura:        "ae5bb495ff795a484bcd9bbbebd4ee005a3cd68317c6779b9ea1be9990a0f472"
    sha256 cellar: :any_skip_relocation, monterey:       "5a9e318d0c586aa06afd97321c3b9598034a30ff7a97b56575d499feadad4d2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "60f6d2e0c7924d2631b4dff96bd1f45e2d43168086279a1909637f04916eb391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf64a1bdc9bda5d335457a71ae65c6e26dd5c13240a938ed83248ecdbd6865fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/grype/internal/version.version=#{version}
      -X github.com/anchore/grype/internal/version.gitCommit=brew
      -X github.com/anchore/grype/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check")
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end