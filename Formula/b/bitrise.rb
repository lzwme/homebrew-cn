class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstagsv2.31.1.tar.gz"
  sha256 "d7205338c9138b6488a57c3198426ef19392fdf6d800876f5c182de7e3ec2994"
  license "MIT"
  head "https:github.combitrise-iobitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9887100ba13ac69b18ee55a59c881ba43a867bffac7e2e206f691fec068feb89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9887100ba13ac69b18ee55a59c881ba43a867bffac7e2e206f691fec068feb89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9887100ba13ac69b18ee55a59c881ba43a867bffac7e2e206f691fec068feb89"
    sha256 cellar: :any_skip_relocation, sonoma:        "357ffa4ae44cf74c35e195723d0f0d5a9bda87f9a9817c40a0ddc5ef703db5e0"
    sha256 cellar: :any_skip_relocation, ventura:       "357ffa4ae44cf74c35e195723d0f0d5a9bda87f9a9817c40a0ddc5ef703db5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58bc3456dc50deafb3751b847b68139a2ced6da6d23988f2cd8d26c5a8fa537"
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