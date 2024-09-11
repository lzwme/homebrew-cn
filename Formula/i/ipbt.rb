class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20240909.a852474.tar.gz"
  version "20240909"
  sha256 "89d95b6c806461ac0dc2096732e266dfb288d08cd8cbe68df83cea9fe0895bfe"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b9aa1ec59dbb646fa05808cd92db6f11cb16027349a2c3d29ad0bbdf56bf76f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc6c27b8f14f12fbca7cdba7ad7f0a2fd31919f6589a2cb331fa2d490cf9d08f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "540baf21bc21eaeac9079d0f674b00a2d5d306a8b0e6ce3fe02ef3c282f49d36"
    sha256 cellar: :any_skip_relocation, sonoma:         "62353f1d79b73c4a914726299f572ec461d23eca472ca88c876f87e91f811fe3"
    sha256 cellar: :any_skip_relocation, ventura:        "9679a46da3f945ff493a4235ad49a562073a6c3da5ce96b33f6731f535dfdf1c"
    sha256 cellar: :any_skip_relocation, monterey:       "1a7a751716a0df2221e6cbfdb528720936a0c2054a219a9012765f39fe1081ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0805604e97eaceb23bc1c424867e48c4f8e158e84ab807963fbe7dce5c3d0d"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ipbt"
  end
end