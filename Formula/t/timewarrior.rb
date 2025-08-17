class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://ghfast.top/https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.9.0/timew-1.9.0.tar.gz"
  sha256 "24365dc1537aa7b0b8c33877df9933a5b8b86e86a25858a5126b1eb4f3bc0b08"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "925f618f1f3ba37fa4d36033e09692dcf32ca6aa2a547a91de46efbea8481bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d155d26dfc283cf59889cfd91d97da45568634eb521f45c8d290fd8a65bbb612"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcbe6eb11a35d7620d3a58ee99d3b938f92bf6c51b3108590aa3e2ab4cd007be"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4b3e9f5c4be6b0621231c47351cfb5f3617c4569530f61bec81581cc728cc4d"
    sha256 cellar: :any_skip_relocation, ventura:       "c3d55472069ba7904abd9915b84b9c2e57d8cd94b983348c66fbb65328ea1d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34814b145decd0a18e5643b470b7c9ab941e6eae05bfedb44d6ab51b74b39b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb54356a9b6b7f667b15ae186da3bbb1fca9fb6a1b36c5c060334c3d26c8622"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"

    man = OS.mac? ? "man" : "gman"
    system man, "-P", "cat", "timew-summary"

    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end