class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.93.tar.gz"
  sha256 "9b871f190020c92425324371357fe040733bf453a48adc7fe14fe31a9f35133c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce66d0deb37e8cce7ac6a53925531083b07b80f0dd546377a8468ed25427ce1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce66d0deb37e8cce7ac6a53925531083b07b80f0dd546377a8468ed25427ce1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce66d0deb37e8cce7ac6a53925531083b07b80f0dd546377a8468ed25427ce1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a92d2d9c1068e038fc7670cd087126fc52d140ea1d5ff1b1ee2d879603ceb001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3bb3e04156bb767c54754bb5e5c3ce67b92c12170e81fd0c5c97d3725ea7ca9"
    sha256 cellar: :any,                 x86_64_linux:  "635002dd799771b0404a5430894f7f27e3af845d766d19c2ef26468a4e64b7ac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end