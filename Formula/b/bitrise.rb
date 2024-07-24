class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.18.0.tar.gz"
  sha256 "9c6e4dac6164c153000b3f6332b79fd62b3d00bb60434201bcff1fccd7cbe7a2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f87cf956dad30a3a7f3fa1c47bee75e3483cc0dc40131f467f063f386c8af5db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e8efc74737ebb32f63e7c76eafabee1c35d0793cab051b6f13cbac800a89319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87b99adbb152186a21d3fcb75fa1268855cdfe48ec1f970aabb33c70801fe89e"
    sha256 cellar: :any_skip_relocation, sonoma:         "200fcea834cc197e5bd5e70d645d10a13172a88833a0bdcc9e347ed6b25d28e0"
    sha256 cellar: :any_skip_relocation, ventura:        "22f1040025732beac42743c3d1b27fa61b19aad2d8aa8e01a9ff7307447787b1"
    sha256 cellar: :any_skip_relocation, monterey:       "93b3ba778421c390ede5fd74b421d63479c51e7122ad85742e86b7f046f4c297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e6069145f31e7ebec4faea6da7c3bc2654a7d0634caa53a2d242dfa35bf6f8"
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