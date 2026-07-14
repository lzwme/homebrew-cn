class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.41.2.tar.gz"
  sha256 "04153d4241d9cec2de1c84f87586d570bdbf3af8ccc1256a307c4691c47764b4"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9a61b032fa66302fdadc9a47258615203a8b856e9e1ebee1a047574aebc933c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9a61b032fa66302fdadc9a47258615203a8b856e9e1ebee1a047574aebc933c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9a61b032fa66302fdadc9a47258615203a8b856e9e1ebee1a047574aebc933c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f83b50b45234d9a7d4c8eb178eaca07808310cd4c4b3e00d97c45f90dd48ece4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f4cb61cbb069253e8af4ced35c8d99dbc5b8fda05e29dfab6e5d72d8ce57af9"
    sha256 cellar: :any,                 x86_64_linux:  "6952b739b3a865954d59742eca052dc109ee488dae75e2e0bfbb33fb883c447c"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
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