class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "7d426048248b922e9f63af133ef09df2b01bdcf9709451ef6826a0a831927caa"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946882048936d169adbc88dd5fc564fb504278942dcec961b78a119e0495760b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8bca158469004c12d9afd1e185f33851a00dbf300052ee2e51025e7a1ecdaf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87108adf98c3eb81c48c323605d75915865650dbfab9842d15722612b03bdb73"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc1ff9746f2ae6ebebbaba61d0c68a640bf676d8335519e10832c74e0a9fc837"
    sha256 cellar: :any_skip_relocation, ventura:       "a25c160eeae8aca4f445f0fdfdb877fda81d469d52f94c94547a31d983c6f9bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539f2eca3aeda9a52b5b836f1f5b59a22f4d63fe35f07252181389d17241b80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47f7c8c399281367328e1aab9826ca236cd7b2013b30f04654b690b8ca53d09b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end