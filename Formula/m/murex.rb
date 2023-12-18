class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https:murex.rocks"
  url "https:github.comlmorgmurexarchiverefstagsv5.3.4000.tar.gz"
  sha256 "cc46a7c4dbc15de9a9ef0b23d3708aabed462afa4d565ac992d3052cea58e760"
  license "GPL-2.0-only"
  head "https:github.comlmorgmurex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f1659796d585ff2ed87016abd316257321bb8de515b6a9fdcc2efc1bc3f6d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "412ccce290b1bd96f699f0856b78af94c77252fe64fb2f5fbaf9d6eaf068be00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bd6fa7b28416a74f5a8b4937cbbfb1c74b97081735ebb5be92e365442471620"
    sha256 cellar: :any_skip_relocation, sonoma:         "871370db0bda055d51025c228a1e8636238833156113ddbce5006a58f43e301f"
    sha256 cellar: :any_skip_relocation, ventura:        "d76cf499b69a430a6a1231578db6515a8181e523448810328134fb2c9a22c1c5"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e6e20c64d4d6f2efbc65a48f05d4557245a74260146dee795893dcb97667d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281ec6bf66f54ccc7c4b7129c70f257c6967056cc92b8d3a3aa968da25dc70fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}murex -c 'echo homebrew'").chomp
  end
end