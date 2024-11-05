class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv3.0.0.tar.gz"
  sha256 "3a6dad87b76ecd59a4c6a2517738cd3b7bd831fcafe1d741fcc5b285532bdbd4"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "878bb421bb73bf6325391498399d212cc31abff31f611dc1684da948bad760ea"
    sha256 cellar: :any,                 arm64_sonoma:  "115815c5ae03a68403255aa5ff4c36bcb72a9bb911c934614dc53c92a354d37a"
    sha256 cellar: :any,                 arm64_ventura: "d55b24c0e0267791add9f0bc9b7acf4b7caa19bd4492cce2f93d2120ab831713"
    sha256 cellar: :any,                 sonoma:        "5e5fcc4968f62f3a62a4973231b6639b5631d0a7d3877573dd35df6c46175d20"
    sha256 cellar: :any,                 ventura:       "01c87a19a4ba57d003b1b1c258e199214bc8ddb9131f071ff854520c3dddc5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5380562d71ac6e5d0dcd41958c51075f28a1414d33ac16cc36aced7880e32c94"
  end

  depends_on "pkg-config" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "taglib"

  on_macos do
    depends_on "gettext"
    depends_on "opus"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "docskew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath".config"

    (testpath".configkew").mkpath
    (testpath".configkewkewrc").write ""

    system bin"kew", "path", testpath

    output = shell_output("#{bin}kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}kew --version")
  end
end