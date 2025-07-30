class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.32.1.tar.gz"
  sha256 "98f1985fd52597f125011b80977fad114be7e41076d5af2e3c826b666d04d5ea"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8be298885e782adafc33734924a8967043a722583a1b1faf060ddc53a044ac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8be298885e782adafc33734924a8967043a722583a1b1faf060ddc53a044ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8be298885e782adafc33734924a8967043a722583a1b1faf060ddc53a044ac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a6b9d7c9c149397eee710966008fa97a2db0c5b7f00852ea96389fafeeb5066"
    sha256 cellar: :any_skip_relocation, ventura:       "2a6b9d7c9c149397eee710966008fa97a2db0c5b7f00852ea96389fafeeb5066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc655d7e820cbf0c2e526056241ecc86171720177da4c7aa9947ed585a4c885a"
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