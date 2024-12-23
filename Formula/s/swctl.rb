class Swctl < Formula
  desc "Apache SkyWalking CLI (Command-line Interface)"
  homepage "https:skywalking.apache.org"
  url "https:github.comapacheskywalking-cliarchiverefstags0.14.0.tar.gz"
  sha256 "9b1861a659e563d2ba7284ac19f3ae72649f08ac7ff7064aee928a7df2cd2bff"
  license "Apache-2.0"
  head "https:github.comapacheskywalking-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "728dabd3e1d8365ae37fb21cbc1a08141be78b2f171f0de9b1ebac833457725a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "728dabd3e1d8365ae37fb21cbc1a08141be78b2f171f0de9b1ebac833457725a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "728dabd3e1d8365ae37fb21cbc1a08141be78b2f171f0de9b1ebac833457725a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfadf539862b32307e496af660a32da07c3d7de286cce07b2f0812b87b5491dd"
    sha256 cellar: :any_skip_relocation, ventura:       "cfadf539862b32307e496af660a32da07c3d7de286cce07b2f0812b87b5491dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874046baa0f6440899485e5f4fde537a34154534e9611b6ae5cf0f4aa86162e8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdswctl"

    # upstream pr to support zsh and fish completions, https:github.comapacheskywalking-clipull207
    generate_completions_from_executable(bin"swctl", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}swctl --version 2>&1")

    output = shell_output("#{bin}swctl --display yaml service ls 2>&1", 1)
    assert_match "level=fatal msg=\"Post \\\"http:127.0.0.1:12800graphql\\\"", output
  end
end