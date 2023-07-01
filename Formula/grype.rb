class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "c0cae06f51a00a9ada57dd3ddd8de052893e42620d8cee49c8874630d5d89817"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20b9148f4c4f748d9f5839e3bd35e65d6e562f9debb0abb775e6c473b91ecf03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "550f321670d1e2f6045754c583dfa7b2a0ac85de604be6c2444db76fb34da2e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d209d819a5b8d7c40260205d4207e4e96e876a97f8140d05d50fe6f5e7e3f903"
    sha256 cellar: :any_skip_relocation, ventura:        "c2534e058f3378655238819693a6752385ad0db7fad21c0d9417e9f9091d5741"
    sha256 cellar: :any_skip_relocation, monterey:       "a27422d02af1ac8184a62dce842c809a32d68d814446a821b7949ca0e9c29531"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dfdb35a780a1eb118b694559ef5eb07c7bc3a875f3cc43229794550b85f88dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb79e850a1daa23838e0e575ca4e1b5e05399c5bed4f527501fef6d3422ce346"
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