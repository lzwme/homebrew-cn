class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "72c719a5a0f8f5fda17ff12ccea1d97f6092edf6f06f04bdcaa171fbdc99cbdd"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a09da0dc5c75eb8a6dfd3fb503abbb170b64c9d3da496970b598ab7d6fb3cb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75ac1e0b3f5f5a054347eb3718f08267bcc4a8f6dfce2dfff524c012c0b8ff11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf3867449f1a5944ae7efe5bfd1ea80d02e295a7b14342180dc11d0455df3052"
    sha256 cellar: :any_skip_relocation, ventura:        "fa46f69e869ce0d3fcf04f36e09d91c13a9c15f45c15509f665e22a4eedf744d"
    sha256 cellar: :any_skip_relocation, monterey:       "397c771bfa2f83fce5fbdc2f05863c1bfa3fe5095faab16c8d1ab64b9a5d4ca5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fa0ce2d09e8bd4051497f3362cdd5d2e2138102589f9b709e33ac596e65fa1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e06cdfed9546d5eeb61d17c28e69acc7118ceb859747fffe9fa7835835c9b1"
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