class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.74.tar.gz"
  sha256 "a9686a563cab3d8402b9ebb29298f021e9d6ab2d60db16999844ae308c276b0e"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6b1129696c8dcd933b14e8a7c2cc203e013aef29acd7598f146d79152ddeb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d6b1129696c8dcd933b14e8a7c2cc203e013aef29acd7598f146d79152ddeb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d6b1129696c8dcd933b14e8a7c2cc203e013aef29acd7598f146d79152ddeb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f578817cd31a99ff3205bd6464695070055223c22a0d52b52debc7c109df0b4"
    sha256 cellar: :any_skip_relocation, ventura:       "94fc18f14e496cef030d04be75b8406b14004b4ba38d5c2a3c0d891d50f1ce56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a302e03db6bdab743b196ed246dd48177df948b9b73ba7abd05c3a4cc0c0618a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end