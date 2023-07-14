class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "5faca9e5f51c5a580af6d73d1dbe4acf31e6804a1b194bc3f25b4be34e660717"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "524c7abb637f0ab0166d1fef2b2d07b4733c85998d3fa998048ec4ad99bd3a3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e85a6a6d4a3ff5e3205a04bf9393088cea467f5b9f8e2f14b3b4b3cdf03271f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91ceb42043d8798316cfc6f62f3854b35d6800e6ce6cf21c1dc2310ab1ab09c5"
    sha256 cellar: :any_skip_relocation, ventura:        "baa49550ffc63ba3ab977f29acdbb392c90e280235cfde353e09729fcd39b180"
    sha256 cellar: :any_skip_relocation, monterey:       "c715c6b3fe3c07eac91d518b6b481da9d38f90da03158a617f474fb8bda86476"
    sha256 cellar: :any_skip_relocation, big_sur:        "07186acbcc1fdb72e59a6d4c72bc5fb484d1a4fc7f47f4e5a0d2f0babe5ac727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00024708b3059413cb37dd872bdf90abf0a5fd0e363e35fafbeaa61ec41392ca"
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