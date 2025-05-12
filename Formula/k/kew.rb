class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv3.3.0.tar.gz"
  sha256 "cc5d1c8f30d9c1d39af452db84bb21c723407b11577c07a108d35f1eaf7dbdf3"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c712be978ea3db621047c10fdc39516d88954b53eb6f2a87063e164eb876de2"
    sha256 cellar: :any,                 arm64_sonoma:  "a79e91436d8469140d9758150f8dc08c835f54e914e49330259362b7219447cd"
    sha256 cellar: :any,                 arm64_ventura: "c8c49addba389a35fd75c8962fa762304b65ab76903b2972d1957c04579beb99"
    sha256 cellar: :any,                 sonoma:        "d88894eb75f99e78fa95d3634ff87a1ba69ad37732ccac33664d7da4c4f3929b"
    sha256 cellar: :any,                 ventura:       "e55d85b4233710730f9312b701798b64a1241f3914da01f655e1547100fab3a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1127b6e3b95392e76323cceac2a4b876b47c92984594d5b198e447d5f877cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4639820ac751eaee647846b14902d9eb9aec3513d9b8a07a758460a2c378fb"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

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