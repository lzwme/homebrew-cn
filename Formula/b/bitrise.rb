class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https:github.combitrise-iobitrise"
  url "https:github.combitrise-iobitrisearchiverefstags2.10.0.tar.gz"
  sha256 "32577f12a87cf124218ac55b33b1988e966d7eb3849305957c644d5e98905cfe"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52a07971115943fc8028b4d671eaaced3e46022a3b8ab7baeaee0f96f4df82e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f9aab31371815b8acb2531698567970f93460758492104a4e070cd396cbd684"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0afd9c1f2237fc34d02472a0a0799154ef009245eb1a82f886e8bc7e7fb1df2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7831636932cc830d8506c37ddafb193985b1ef07d8cb9304b8acf0d82cd2918d"
    sha256 cellar: :any_skip_relocation, ventura:        "54ae87ba54649a23adb75cf436595c4d4a8e6ca99b6cf1fbd975828fbd6e76c3"
    sha256 cellar: :any_skip_relocation, monterey:       "5545c03c673c93dd71b989b108c0d94fcd8aa96fd4b0ce6620a0ac0b3de57a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2711a592b225dd2d00c9824ef259a4ef6e43596d44131b15064a850b237477dc"
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