class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https:wiki.ubuntu.comKernelReferencestress-ng"
  url "https:github.comColinIanKingstress-ngarchiverefstagsV0.17.04.tar.gz"
  sha256 "60c37d8b1effc5772fb30f638e20b1de01e0488e274e283301c3fd6c707d8538"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22d961d0ec28998bd23cccd7353899eae741122ebfe9c1d67fd5652e0374bad5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cd7cb088295a50ea51bc0dc1385bfb356319cdf7f5542f2db7bfab0d6b1c846"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ccf6dcc973331d6acb02251b5effe7606ff914439fcabd0ed18319c32d08340"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c6141663bd4f8da1c1f770ab1086f77f3f87e4dd91f7edc97c194a5e16f3f2b"
    sha256 cellar: :any_skip_relocation, ventura:        "89159027887c6a9734f95743f9a49d1700c61df1470f0ccd53274a65931149e8"
    sha256 cellar: :any_skip_relocation, monterey:       "9e14acef3c912d8da3734ebe8564f415f29cee094cf2b83981e5c40ceeaa5f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b3b007a24184d84548a6b7ac26678a01f0df964383578de03cfff3abb65df4c"
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