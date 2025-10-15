class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.34.4.tar.gz"
  sha256 "4bde9705cef33f049d1ca6667c0607518a75d84d2bbcd03c78badad9840ca614"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de7afb8e9e9dc7525d8f48858d62cd9d005eca1c35848c3b07f51c8a73426bdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de7afb8e9e9dc7525d8f48858d62cd9d005eca1c35848c3b07f51c8a73426bdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de7afb8e9e9dc7525d8f48858d62cd9d005eca1c35848c3b07f51c8a73426bdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c950526fc686d99f36eabcf8b389fe92c120775b0cf6b03553906f048249b731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe581784aad0bf472cfb70361996a2529562b471c1603b8f5a50316e188bf1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9c389b347b3ff677359276b7f60b122bbdee109316827d96a4ca6db2375e81"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
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