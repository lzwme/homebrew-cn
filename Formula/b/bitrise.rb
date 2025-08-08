class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "5775d12868b03ec035f9e6942bcc3ecb6f321cf63c8ddfd99daca52ca01535af"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227a2ca7d4eb576804a8d3b5830632d36ad0d82e291049ce883c72ceecb4d987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "227a2ca7d4eb576804a8d3b5830632d36ad0d82e291049ce883c72ceecb4d987"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "227a2ca7d4eb576804a8d3b5830632d36ad0d82e291049ce883c72ceecb4d987"
    sha256 cellar: :any_skip_relocation, sonoma:        "42dbadf3e9787dbcdec2d79908330107549a202d48315b07d87ba448497d9caa"
    sha256 cellar: :any_skip_relocation, ventura:       "42dbadf3e9787dbcdec2d79908330107549a202d48315b07d87ba448497d9caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "657934598d10e72f183d17c8ad4c6e5273867dd02b32af0809aec0dae8798705"
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