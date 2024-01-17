class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.8.0.tar.gz"
  sha256 "5d4fdbbfb1cf9def248e84b75594c9e6cb96d580a9b0e581af189cadd71e263d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3a0194fc36d65fea0bd20beef7503eed4a73f418f40d1ae507fa9d8d911196c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e759601188d418f2a7dc1a73382d33232b1c3e74efbf0524d6d9582280a4676e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebafaae1b60b8cb72ea12322382bbe5ebe201f6a51e23e88fb31736739b319c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0ebd7c9bf8b4f9ee4cc90b16713f5d7c373ee4f71af0c7ce72615fb6b5cbe32"
    sha256 cellar: :any_skip_relocation, ventura:        "629e5f5e85ed13e57b910b11af02429c39387a0f748435bc21bcd5f1083f8e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "bd174105f3a49c348a45664e162c43b5dff856c1576ab1db0a3c78a6606ed922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee6cdd6d2f89dab0310ce27c066ce634c56caf1ca747407e45decdc7efe2fb7"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.combitrise-iobitriseversion.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https:github.combitrise-iobitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}bitrise", "setup"
    system "#{bin}bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath"brew.test.file").read.chomp
  end
end