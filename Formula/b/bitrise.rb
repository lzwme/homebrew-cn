class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.15.0.tar.gz"
  sha256 "cfeaae4f915654be56c8bf873e9995fd7ce129b37e94996079dc04e98f861b33"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11f5da72376330d042f753eae412d7dd2ec6c6b32949c1ddb03820265184926e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14eb5930d4ac50f93fbc3831f384bae0a505853fe35a56449fdec33e680f05d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e82d48d7015485f9868364cebbee19859269bae606607d95479ac0f7a80befb"
    sha256 cellar: :any_skip_relocation, sonoma:         "76997a4aafb429cbd4d8b86fa6d63d8ad00d344486645ec9ae56bd021f50beb5"
    sha256 cellar: :any_skip_relocation, ventura:        "65aab9656596845a4666d561ac27f1aecb68c317568c10e54087385811f7c46b"
    sha256 cellar: :any_skip_relocation, monterey:       "685b299bf5a83f0f01dac948eddc5f2a51cf889f4a7b69dec644d758778206e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b670c6757eb5fe8b75d59938dc2d129a3cfcc0ac54d6bacc4177c2572f40b1"
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