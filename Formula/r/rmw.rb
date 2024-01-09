class Rmw < Formula
  desc "Trashcanrecycle bin utility for the command-line"
  homepage "https:theimpossibleastronaut.github.iormw-website"
  url "https:github.comtheimpossibleastronautrmwreleasesdownloadv0.9.1rmw-0.9.1.tar.xz"
  sha256 "9a7b93e8530a0ffcd49f1a880e0a717b3112d0ec1773db7349bac416ee1a42b3"
  license "GPL-3.0-or-later"
  head "https:github.comtheimpossibleastronautrmw.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:[.-]\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "192bcd5660dbe13af7e1d3362237d9a4c27ae80ab7f176a23aa3dea3f2dea362"
    sha256 arm64_ventura:  "54b07240896ade22480fe64bbb2eda5327c518ffaef594f934609b55dc97fe79"
    sha256 arm64_monterey: "5fead6bcc25069aac02b5227efeb3a01d1c53742e2d6427204a8b7991ba19613"
    sha256 arm64_big_sur:  "d19a1d0c5634dd8ee234ffbfc680026ce7117a8cbe751aadb38e7ec0463f243e"
    sha256 sonoma:         "dd7a43c42d76439dc993c7d1cb3b6ebee9269fcca056f2ee7e29cfd84294c5b7"
    sha256 ventura:        "99514dcb65578f1cfbda839fb10319c1b9babdbbfccfbc742e426f6192ca8a05"
    sha256 monterey:       "1cf338232502a0f45b172f5ba00836ad3f429a1aaa30d150fe187d7c12bb1ad0"
    sha256 big_sur:        "856626a1bed49ede59542a94607b33ba8841bdcf710ef21c4181a51d8daf8e15"
    sha256 x86_64_linux:   "6850a908c22cb35663452467d6ede9681e7fe478b009c91538b4a49c2f5cb788"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "canfigger"
  depends_on "gettext"
  # Slightly buggy with system ncurses
  # https:github.comtheimpossibleastronautrmwissues205
  depends_on "ncurses"

  def install
    system "meson", "setup", "build", "-Db_sanitize=none", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    file = testpath"foo"
    touch file
    assert_match "removed", shell_output("#{bin}rmw #{file}")
    refute_predicate file, :exist?
    system "#{bin}rmw", "-u"
    assert_predicate file, :exist?
    assert_match ".localshareWaste", shell_output("#{bin}rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}rmw -vvg")
  end
end