class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "bd6a9d72e022f3454130f4a5b1807aa7c5fb641e6cad509bb3ba977737f098fd"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d523b1b0721165a46d7748cfd7e2852f669c47db29f2a582542e761440060500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed87605c9eb401c75945b17cdf36122a4ef80abb848cd0d55a7d8d159c5c405c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "645e307c822ee25e05549b1cf7d3baf93201bca609411f4f67c74c95f38fdc0a"
    sha256 cellar: :any_skip_relocation, ventura:        "d17e419666490c5596dfd539c107141a652ca94334dab5ba20cf3573fb095d89"
    sha256 cellar: :any_skip_relocation, monterey:       "5332214c402104afaa17ebf79c7c1b8656ebe5bfeb68a66aeebefdb478791b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02c1fd1360e62618c502ec655a9551403567ae788007d9ceecef51e4588be0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4100af989a2bf7627184d2aa0eb0b6b32ce64a78b030abca90b03efd6eedac"
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