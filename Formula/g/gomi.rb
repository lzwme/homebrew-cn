class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://ghfast.top/https://github.com/babarot/gomi/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "ec8805aba669b8ee57268196f098f366bf9eddecda57a3cac35d4853e08b04b9"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ab496828108ae81a28142ea18d295b202f87a0785802230ce20e904f97b20c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ab496828108ae81a28142ea18d295b202f87a0785802230ce20e904f97b20c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ab496828108ae81a28142ea18d295b202f87a0785802230ce20e904f97b20c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1a72e3a52c1671c1ec6406f238671b66cd9e5c54a1238c6633d6a196626a679"
    sha256 cellar: :any,                 x86_64_linux:      "f0367933e7b39bfa2c8928a4f7899c49f8e9b449f3c6f192f42bc0b08aad1ff3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["TMPDIR"] = testpath

    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end