class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https:wiki.ubuntu.comKernelReferencestress-ng"
  url "https:github.comColinIanKingstress-ngarchiverefstagsV0.18.06.tar.gz"
  sha256 "f3197c010b1ac23b015a6f8e8c84a24cee02750bf41a1527379ccb31ca4f889a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "321f00e86ae27c94d6a25ce7c75e202a42c15384a383424e6c197d8e98bd93df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2f3456f7167d888b34ff97bf8a139ee2d11f799e22370ddbca44d1867ceb536"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e55aa7c019ae71faceaff9e9e26d23fdbdff647047281d06572a30c77b84092a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6721e4ed349fa8e314ee1362cb19779827f349b28fc6ad554907c5a4894d0cbf"
    sha256 cellar: :any_skip_relocation, ventura:       "219e523de527129d7245863e0e4fe2c7e121848911daf694f8777e291dadbf2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cc36d5e866a641a842c05ecca20d557196bbd1ccf16aa408b86a084ca670a31"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "usr", prefix
      s.change_make_var! "BASHDIR", prefix"etcbash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completionstress-ng"
  end

  test do
    output = shell_output("#{bin}stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end