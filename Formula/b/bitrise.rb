class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghfast.top/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "e0b3202b2a22ef2db10b8d5f50278cad06022d6102697829be95cbaf219a6bc5"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04bea335dde429b51fe23c873a420309b78cf4f8a6066e9fe3c787ad62896715"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04bea335dde429b51fe23c873a420309b78cf4f8a6066e9fe3c787ad62896715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04bea335dde429b51fe23c873a420309b78cf4f8a6066e9fe3c787ad62896715"
    sha256 cellar: :any_skip_relocation, sonoma:        "daab0358f5876fb5dc264bf5e14d4977baf11c7facd279e1e1c249be846497d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7fa9a00466e802fec88b85812e449ae162d69c9ba5087c6e6812f7383dfff0"
    sha256 cellar: :any,                 x86_64_linux:  "ac26600d104de6ede67ef4338f3beb06ee4dc1c26dd0b74fffbbea736532317d"
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