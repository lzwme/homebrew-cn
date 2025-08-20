class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.33.2.tar.gz"
  sha256 "7d6510c5b35e82cf74a50e52287568ff227ac0bc3f486eb604be70913cbcb108"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91deac1c3ebbd9085e123d9a90666af6303a0129f2a5e6eac7fca6f49ed83fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91deac1c3ebbd9085e123d9a90666af6303a0129f2a5e6eac7fca6f49ed83fa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91deac1c3ebbd9085e123d9a90666af6303a0129f2a5e6eac7fca6f49ed83fa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6db6ef207a11b87750fa86c39a8e85c57c28b940ee3cc026162911c57bc0377"
    sha256 cellar: :any_skip_relocation, ventura:       "e6db6ef207a11b87750fa86c39a8e85c57c28b940ee3cc026162911c57bc0377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90192b0e7e1457a2fcd07905759d43edd69e3ae9e42df79e193d2128cf1bd735"
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