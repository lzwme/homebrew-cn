class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https:www.boost.orgdoctoolsbcp"
  url "https:github.comboostorgboostreleasesdownloadboost-1.83.0boost-1.83.0.tar.xz"
  sha256 "c5a0688e1f0c05f354bbd0b32244d36085d9ffc9f932e8a18983a9908096f614"
  license "BSL-1.0"
  head "https:github.comboostorgboost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7937a18c05e7bc667834d66bcbb9813e045850d60a27554a5ca3976f880fe8b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "942063a3ed8a10a8f184d9a4cd5e8cb5c1a759791d3f1703af63c5f9153ea6b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65fe213908ca1c81e37d1bd4085e435a810c692485fd8cae7188151aa77443e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "61d0aed611a3c111c31d2a2700b8f596a464f815bb88102d6fa42b5b7831d1f1"
    sha256 cellar: :any_skip_relocation, ventura:        "d4d6e592eb31c30f6c704f28fd8433d1bb509229ec7dedaf8c4c5386c632a9ec"
    sha256 cellar: :any_skip_relocation, monterey:       "19e92c43386a4fa956fcb908bc0cbc744ca60eb7f854818105f177720d83069c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3de00e56a9473a25d3af260aad76847cb4e1bdf96e4ffd56f92e12952f6cf3a7"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    # remove internal reference to use brewed boost-build
    rm "boost-build.jam"
    cd "toolsbcp" do
      system "b2"
      prefix.install "....distbin"
    end
  end

  test do
    system bin"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "."
  end
end