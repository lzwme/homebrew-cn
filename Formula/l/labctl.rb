class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.101.tar.gz"
  sha256 "7f855b5c66f48af6783011bb6fc001851d567ff5ed0f49cf86feb08af433bf25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ba676ed134d93bca1e7c5ad69314ce2b0912b491fa4bb09fd8f6a2b0a0870d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba676ed134d93bca1e7c5ad69314ce2b0912b491fa4bb09fd8f6a2b0a0870d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ba676ed134d93bca1e7c5ad69314ce2b0912b491fa4bb09fd8f6a2b0a0870d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b494e5f3eab1f88cbc6a88196ca54c9b1b1ec2e11d0cce8924dad6a8d1c364bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1708ce46401100a6e9c5ecc157cf51761209beedd30c3631bea0088467e4c6b9"
    sha256 cellar: :any,                 x86_64_linux:  "de36282db13720e017160fbc2e59bfd81830456f2f3742513ddf2991ec737922"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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