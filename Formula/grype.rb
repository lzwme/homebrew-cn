class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "a55aa18498a2b67f7bdcfb0fac0746a351ceb8a2e9da0842ab1a68a07f0ffa65"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88d28a207d7e8121b8a043370a357507bb8b17e8010bd79fe6604d61b2c9282a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f0625739a2e407cd3575dd3f8ee5a544c05985ded1b467396cb7bced82d4df1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "981fbc592fcb77a0454ad7fec445312ef1ddbcb24e98fed16f81ded0134fada2"
    sha256 cellar: :any_skip_relocation, ventura:        "251ff09fffd0ae00f9762af8e2dff082a5994462ee86aa74f19b901d3907c0d2"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a8ca0b0b09af43c08de174cae24ffef6b47df49df8b03d66c01bdd52117489"
    sha256 cellar: :any_skip_relocation, big_sur:        "7964a26f9621b8b07192014cda26373fe66d9982ce5390ebac769e556683cc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9261c5c117e70a5bfbda9f2f956711b61a8873a906c0479a16ea4f09d8238d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/grype/internal/version.version=#{version}
      -X github.com/anchore/grype/internal/version.gitCommit=brew
      -X github.com/anchore/grype/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check")
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end