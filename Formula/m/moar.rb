class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.23.13.tar.gz"
  sha256 "80c27ac2b1b4d2012e213b04dabe7395ef66ddfdda47a0c46fce0ec1533a5616"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8338953ee517e6c990add14767a364db121a28437adbd182be923132a67322d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba93e53bc344876776dbe54ef6e4f83ea10bf07b3038b9af2fce18d0c366a92a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf03753e6979df4575661ce2d70d6bbcf7622bb8e3b45f192629d282516ee838"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a52596ca6bd7e9d299d272fcbe278e7805aabf4200cfd24752952da65e87d5b"
    sha256 cellar: :any_skip_relocation, ventura:        "2c9e16ac91551be6bc5d180604783e57ec01f99f9844ba18c070a3b250fe08cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e57e06f37b0b1b2ddb19327526335701cda84f2aa5aa30bf6d1f14e90eab72ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeee13f99745e74cabf4aac0e44a55ba50c5a0d329347da74f3e43cd3501c889"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end