class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://ghfast.top/https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "7545ee98100a49de749d20c9e47a4dfb8988a286077ebc4e8c014526b64d03c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af581ac2799fd2e5232f7fed0daa893e5f70504b293491c33e6d024d077cfc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9af581ac2799fd2e5232f7fed0daa893e5f70504b293491c33e6d024d077cfc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af581ac2799fd2e5232f7fed0daa893e5f70504b293491c33e6d024d077cfc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b74a3cbe9e2ed3d058c82025763a5d4c1d692fdd09132cc8901837bfd0f4e3c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83e6780446cbddcbdce8877c827fbedf5e8244d2284a5d40ab7826de2c5255a7"
    sha256 cellar: :any,                 x86_64_linux:  "e95ddebba0dc6fd9bafbd6900b923e7c518a43fc88ddcdb89eaec002df5ee81d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end