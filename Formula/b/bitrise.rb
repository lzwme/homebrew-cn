class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.16.0.tar.gz"
  sha256 "fa1fdda7e9836caf5bb715e32f1580c14cbadb29c99dd918001c34e4223fb430"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23415985790c03684b0aca1dc295dd2ea278dfac9e05e4c45e3271bcb1bb217d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7fc8a6559e6f6a48bc9a7d5408343a5c7794bc3c9dbdf8e65746acb64dbba18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a41b32729c4a12f25a24823bf287b2777f0af39429941ea6f05e3d0b77fa9235"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2a85cc201344b08596aab751ccb28fd7af1e4e50efd10f4c8a12c7f1f87ee36"
    sha256 cellar: :any_skip_relocation, ventura:        "dc087899312bf8fbe4e485e36110df83562425279e80d66c4fa8138c8a0ea87e"
    sha256 cellar: :any_skip_relocation, monterey:       "db2f489352d97796f0667b9ed1e1bc8db260faa741994fe6c0302d520dca34bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c18ddf09e9e709eefb4f2be65360efe5a2096959a1d495c16a7aef153236c8b2"
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