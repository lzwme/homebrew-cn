class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.67.tar.gz"
  sha256 "6e6be8080ce2fd7d2fdca7e68f52ffff8825460c229fcadc15120e4a24447f92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06242c71483a30986ba585ef850151cb3ba4ff5d56c66fe6b62372f726ab74a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06242c71483a30986ba585ef850151cb3ba4ff5d56c66fe6b62372f726ab74a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06242c71483a30986ba585ef850151cb3ba4ff5d56c66fe6b62372f726ab74a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "99e0ff5729cf810ebb77fce79135a9e263288589fbf0ed793ce50a823cef68a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4f40542583b7211f5be86ba06d7340751acda83f8f9aad1fc5de6b4d9bc4e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd8d06aadad28fd7d063eaa7148728d4c93d311b1b1ce547e148dff82114a38"
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