class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.43.4.tar.gz"
  sha256 "5f1432c3c160878f56735d02f2f0c06c89fd0fa4223a75e90ec8aa71f390efca"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "618f80c5b50027eb815ca898f78c9cf64691f77ded794d614b8e0073bf729708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "618f80c5b50027eb815ca898f78c9cf64691f77ded794d614b8e0073bf729708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "618f80c5b50027eb815ca898f78c9cf64691f77ded794d614b8e0073bf729708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "728a0f8ba421fabc96f2b4eaea4b3ca1f5a2127c7f2905ffd123b387de5d818c"
    sha256 cellar: :any,                 x86_64_linux:  "eb3c3e1c5c7571c808c3ff738046cca32b060443756154be64d86d406a8de221"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitrise --version")

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