class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.28.0.tar.gz"
  sha256 "e6db749ae7f282ff0935954aa3d8312360310ee7efadce684ef4a42f5c25892c"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642606860e6cb2e7887e373fb1c5eaf3ffd4a1b83d0b32b4d3876a984b11aa5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "642606860e6cb2e7887e373fb1c5eaf3ffd4a1b83d0b32b4d3876a984b11aa5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "642606860e6cb2e7887e373fb1c5eaf3ffd4a1b83d0b32b4d3876a984b11aa5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ca81e4285d75a6e8713d6112e2e3637109e9fe2e070c5f8303a39717e5b1732"
    sha256 cellar: :any_skip_relocation, ventura:       "2ca81e4285d75a6e8713d6112e2e3637109e9fe2e070c5f8303a39717e5b1732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b1cd26660d17b1b329b00f7cdf69566b8c500986ddb325da1797c4d2f61a44"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.combitrise-iobitriseversion.VERSION=#{version}
      -X github.combitrise-iobitriseversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https:github.combitrise-iobitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin"bitrise", "setup"
    system bin"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath"brew.test.file").read.chomp
  end
end