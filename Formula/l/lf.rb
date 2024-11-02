class Lf < Formula
  desc "Terminal file manager"
  homepage "https:godoc.orggithub.comgokcehanlf"
  url "https:github.comgokcehanlfarchiverefstagsr33.tar.gz"
  sha256 "045565197a9c12a14514b85c153dae4ee1bcd3b4313d60aec5004239d8d785a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aec8a0321eec8305ebe0bb252fd830e749ba7f91943a18a7be398cd5d4a840e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec8a0321eec8305ebe0bb252fd830e749ba7f91943a18a7be398cd5d4a840e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aec8a0321eec8305ebe0bb252fd830e749ba7f91943a18a7be398cd5d4a840e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d254dbd94bb999d85c0de187101aeedaa8cb0b2315b2ae3b780befc5a1588e8"
    sha256 cellar: :any_skip_relocation, ventura:       "7d254dbd94bb999d85c0de187101aeedaa8cb0b2315b2ae3b780befc5a1588e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88d3cc1c9fc4c98ab4574cbfecf91305aebf12bcfc5daa3cbc4246e0e4d2a212"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etclf.zsh" => "_lf"
    fish_completion.install "etclf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}lf -version").chomp
    assert_match "file manager", shell_output("#{bin}lf -doc")
  end
end