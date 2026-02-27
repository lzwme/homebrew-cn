class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "33624063b6086e1e7f01a7aa66f647b45e1ccb4c97dbbb59e7423d9ea780d609"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b046939bca603372b68605dd53267a840d53944a9f0dd0e4ca78f6af5b5f70f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b046939bca603372b68605dd53267a840d53944a9f0dd0e4ca78f6af5b5f70f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b046939bca603372b68605dd53267a840d53944a9f0dd0e4ca78f6af5b5f70f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9538d76a00d7e149b3258fa51330340d6ce6149f4efd94094b15200e483e05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd7710b15eda5b9e5a88f0c4d4ef64be154a65b5dee6b303e63ac522c74c9caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb3f4c8d601411ca53691291602f4b76acd5873f3c1f04b967ba8019e3b5cadf"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end