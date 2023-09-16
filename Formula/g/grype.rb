class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.68.1.tar.gz"
  sha256 "cd8bc7eadd8ab4a9ff872dc30142e8451f0580380f292360d020cea3f9d51309"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f4b519b0c9712625fe211d4c06251b75954d845c9f3c551d9fcf90dd9aea09e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42ca6eee6982148fabaaeb28a0d6497bf1ca95b5db3f51ea52f17cd605152c91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6db9f8dd4a6e721007179e457c6e4ea15be681724486fbc029653ebb28f4794"
    sha256 cellar: :any_skip_relocation, ventura:        "769d0bb437c2ea1b31c723159a311aaea040b2f0723161d243a608bb03a1ba51"
    sha256 cellar: :any_skip_relocation, monterey:       "76c4e47a18984b242da069d6c39f96b1c2e5cfad8e098638cc1747e46f5b3892"
    sha256 cellar: :any_skip_relocation, big_sur:        "968d5741fba45702f4b1607c2dbd0fe8d1cf670c2d92554b213813da1bc23f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41c9453aac64647d2a52461d9ae4473d8339b5e974a8e1664bd361f6c266bd4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end