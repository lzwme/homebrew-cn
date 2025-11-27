class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.35.2.tar.gz"
  sha256 "616e6de08c780014a6bf1656d94d2144a59b6fde6433c24fa1ab514d5cdb3b7b"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "858f4d9986bd49175a367a90cca9ade363b14c61a4eccdc03800fadffd87308f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "858f4d9986bd49175a367a90cca9ade363b14c61a4eccdc03800fadffd87308f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "858f4d9986bd49175a367a90cca9ade363b14c61a4eccdc03800fadffd87308f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e91edc3a729d59e7b6fc8c5f72ad3eeedbf34d210d2376dd314c09352462ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb95e03807c12d9b278ad81fd51edb2896ec2a4a1391933aac875b9c4277f1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a869209050a8fac32723f22ab311f964a180149a729894b35601f4fa690945e"
  end

  depends_on "go" => :build

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