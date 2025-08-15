class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.5.0.tar.gz"
  sha256 "d418252e111b1aa2562e93968205c8fd1507fab19032531875adc11b4740babc"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "27e247518f69e6791a20080798c3de87e84dad16e97a525512e104c594326906"
    sha256 cellar: :any,                 arm64_sonoma:  "7a160af234c1afb3b6aa82d126ac29d6622616c05fd95f96614384e569175030"
    sha256 cellar: :any,                 arm64_ventura: "b6fc96b8c4b94ec51db69e559f965e0d6c0f6c2a2d20b370be560dbc1d223a94"
    sha256 cellar: :any,                 sonoma:        "bd1bb588b0e7dbf0b168ca502c0c758c3d9e069c0a142a4ecc31a88a2b5d9e85"
    sha256 cellar: :any,                 ventura:       "e1b76f9c1b553f5f63839f36f3c062708b6e9208c6721bc39426efeafea7cedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a901467f77f2ca8b0ab4e363ed6b0684586928a23911b9c833baaa54a4224ef0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "gettext"
  depends_on "glib"
  depends_on "opus"
  depends_on "vips"
  depends_on "xz"

  def install
    # libvips is a runtime dependency, the brew install location is
    # not discovered by default by Cargo. Upstream issue:
    #   https://codeberg.org/simonrepp/faircamp/issues/45
    ENV.append_to_rustflags Utils.safe_popen_read("pkgconf", "--libs", "opus", "vips").chomp
    system "cargo", "install", *std_cargo_args, "--features", "libvips"
  end

  test do
    # Check properly compiled with optional libvips feature
    output = shell_output("#{bin}/faircamp --version").chomp
    assert_match version.to_s, output
    assert_match "compiled with libvips", output

    # Check site generation
    catalog_dir = testpath/"Catalog"
    album_dir = catalog_dir/"Artist/Album"
    mkdir_p album_dir
    cp test_fixtures("test.wav"), album_dir/"Track01.wav"
    cp test_fixtures("test.wav"), album_dir/"Track02.wav"
    cp test_fixtures("test.jpg"), album_dir/"artwork.jpg"

    output_dir = testpath/"html"
    system bin/"faircamp", "--catalog-dir", catalog_dir, "--build-dir", output_dir

    assert_path_exists output_dir/"favicon.svg"
    assert_path_exists output_dir/"album"/"index.html"
    assert_path_exists output_dir/"album"/"cover_1.jpg"
    assert_path_exists output_dir/"album"/"1"/"opus-96"/"8zjo5mMqlmM"/"01 Track01.opus"
    assert_path_exists output_dir/"album"/"2"/"opus-96"/"visBSotimzQ"/"02 Track02.opus"
    assert_path_exists output_dir/"album"/"1"/"mp3-v5"/"tbscAvvooxg"/"01 Track01.mp3"
    assert_path_exists output_dir/"album"/"2"/"mp3-v5"/"d3t6L5fUbXg"/"02 Track02.mp3"
  end
end