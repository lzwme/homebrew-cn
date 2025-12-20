class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "1283be7378da684f60d188e95aff54096f539a2c7e25b75efe2a778019971d6f"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19db0c0a2729ac4b74e09af93b6fd52b36b396055516e0bfd3574681ede00ada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19db0c0a2729ac4b74e09af93b6fd52b36b396055516e0bfd3574681ede00ada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19db0c0a2729ac4b74e09af93b6fd52b36b396055516e0bfd3574681ede00ada"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc2f3e8ae7424c3c1a2dbe6483e74dfe1c178e6404ee54d06dfd004a04a51ff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b0220d32d7dd3fd8fa8603f8817b58244c0cdcfc9dc5d35bd1abdf1c5bf34be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6967fa62f4c36430383cdf494047a5e90557efc4ce54d5d3f2b2af78daa5a0c1"
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