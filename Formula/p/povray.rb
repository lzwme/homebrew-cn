class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://ghproxy.com/https://github.com/POV-Ray/povray/archive/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 8
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f6d83b7fe7cf8a025c54e6c1337db44d85fef5d313fd68d7b67e739277153c17"
    sha256 arm64_ventura:  "e506fa0c7102371bd0abdd29d94ef0ab6108562aff7511f360a2b3fa8a91ff9b"
    sha256 arm64_monterey: "78193365b898aa0aa2f1f373a54093c15ddec2508643c98319b861cccc0437b1"
    sha256 sonoma:         "1a2c5f3ff51d4fe94fa43a785561fe9c1ba9e0148807dfb44b441f088363a265"
    sha256 ventura:        "c4dd8387f1cbe667223471693a17d92243f6c11c063ae18f742a60111b4b94c7"
    sha256 monterey:       "9c22502219b5ba80d3a4e54537e52452962970e49cb36f69047524eda6a4c1de"
    sha256 x86_64_linux:   "3781ace72b6106ae7e34c80e91baa8f05ab6657cadbe5eef33688a770e943a37"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  def install
    ENV.cxx11

    args = %W[
      COMPILED_BY=homebrew
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-openexr=#{Formula["openexr"].opt_prefix}
      --without-libsdl
      --without-x
    ]

    # Adjust some scripts to search for `etc` in HOMEBREW_PREFIX.
    %w[allanim allscene portfolio].each do |script|
      inreplace "unix/scripts/#{script}.sh",
                /^DEFAULT_DIR=.*$/, "DEFAULT_DIR=#{HOMEBREW_PREFIX}"
    end

    cd "unix" do
      system "./prebuild.sh"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Condensed version of `share/povray-3.7/scripts/allscene.sh` that only
    # renders variants of the famous Utah teapot as a quick smoke test.
    scenes = Dir["#{share}/povray-3.7/scenes/advanced/teapot/*.pov"]
    assert !scenes.empty?, "Failed to find test scenes."
    scenes.each do |scene|
      system "#{share}/povray-3.7/scripts/render_scene.sh", ".", scene
    end
  end
end