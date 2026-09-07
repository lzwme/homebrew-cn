class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghfast.top/https://github.com/strukturag/libheif/releases/download/v1.23.4/libheif-1.23.4.tar.gz"
  sha256 "d0c02b4b0e978f34a1974b6f3eea7975a537bf7a9195ffeea38e7242ff316fdd"
  license "LGPL-3.0-or-later"

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9cd1b18c4425d5e0e3b443d4ce55275a8ff669b6004deef6272d4ebc317379fb"
    sha256 cellar: :any, arm64_sequoia: "e97a838b80bee6f36eceeadf2e1e14a0866284929025d0daca9d4780490290e2"
    sha256 cellar: :any, arm64_sonoma:  "2b4c4ecbb485d54f375d9ea33f865f2f2f9be1498ca5a500ecaea14315168dca"
    sha256 cellar: :any, arm64_linux:   "9f851327fd6ba3af76802d167c82b36ffc3d8e240d42c7e4961f73a48cf5727b"
    sha256 cellar: :any, x86_64_linux:  "6b93ce92fbcc185f1d17ecf8533532fcc06d900c40127f3f5a047c7203571f74"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "openjpeg"
  depends_on "openjph"
  depends_on "rav1e"
  depends_on "svt-av1"
  depends_on "x264"

  def install
    # Enabling plugins for "popular" formulae
    plugins = %w[
      DAV1D
      FFMPEG_DECODER
      JPEG_DECODER
      JPEG_ENCODER
      OpenJPEG_DECODER
      OpenJPEG_ENCODER
      OPENJPH_ENCODER
      RAV1E
      SvtEnc
      X264
    ]

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath(source: lib/"libheif", target: formula_opt_lib("libheif"))}
      -DPLUGIN_DIRECTORY=#{HOMEBREW_PREFIX}/lib/libheif
      -DPLUGIN_INSTALL_DIRECTORY=#{lib}/libheif
      -DWITH_AOM_DECODER=OFF
      -DWITH_AOM_ENCODER=OFF
      -DWITH_EXAMPLES=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_LIBDE265=OFF
      -DWITH_OpenH264_DECODER=OFF
      -DWITH_X265=OFF
    ] + plugins.flat_map { |plugin| ["-DWITH_#{plugin}=ON", "-DWITH_#{plugin}_PLUGIN=ON"] }

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build/libheif/plugins"
    system "cmake", "--install", "build/libheif/plugins"
  end

  test do
    libheif_bin = Formula["libheif"].bin
    decoders = shell_output("#{libheif_bin}/heif-dec --list-decoders")
    encoders = shell_output("#{libheif_bin}/heif-enc --list-encoders")

    %w[dav1d ffmpeg libjpeg-turbo openjpeg].each do |decoder|
      assert_match decoder, decoders
    end
    %w[libjpeg-turbo openjpeg openjph rav1e x264].each do |encoder|
      assert_match encoder, encoders
    end

    system libheif_bin/"heif-enc", test_fixtures("test.jpg"), "--htj2k", "--output", "test.hej2"
    assert_match "MIME type: image/hej2k", shell_output("#{libheif_bin}/heif-info test.hej2")
  end
end