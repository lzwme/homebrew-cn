class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.19.0.tar.gz"
  sha256 "828aa9a069e71fb5613785f7cd0995c568e0f6dd0933f1510e6ae46a20bf0a03"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "bca8dba578ae518a763db1ee7f16a700d5bc1fea99ba7fe3f2cfba57c9603530"
    sha256 cellar: :any, arm64_sonoma:  "66cfdfca710af89746097abbe864fa7e213b9c7b7c06361f40fcb6a2e8d9122e"
    sha256 cellar: :any, arm64_ventura: "299f14748e29823b721e0cf3c5325db74e32c3a42d23f744beb6e20f0ad1a741"
    sha256 cellar: :any, sonoma:        "049174f5239bf2b51fe23e20fe5e4c247282eece48e87449ff7f5165cd19135e"
    sha256 cellar: :any, ventura:       "f4033029030264bc5241e63324d339b6b7cae75ad547b800ab42750f0734afe8"
  end

  depends_on "opus" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "gettext"
  depends_on "glib"
  # Brew's libopus behaves differently in linux compared to macOS and
  # results in runtime errors. Further investigation and work on this
  # formulae is needed to support linux builds. The upstream project
  # provides their own mechanism for linux distribution. Brew is most
  # valuable on macOS, where there is no other suitable package manager,
  # so for now, restrict this formulae to macOS.
  depends_on :macos
  depends_on "vips"

  def install
    # libvips is a runtime dependency, the brew install location is
    # not discovered by default by Cargo. Upstream issue:
    #   https://codeberg.org/simonrepp/faircamp/issues/45
    ENV["RUSTFLAGS"] = `pkg-config --libs vips`.chomp
    system "cargo", "install", *std_cargo_args, "--features", "libvips"
  end

  test do
    # Check properly compiled with optional libvips feature
    version_str = shell_output("#{bin}/faircamp --version").chomp
    assert_match "faircamp #{version} (compiled with libvips)", version_str

    # Check site generation
    catalog_dir = testpath/"Catalog"
    album_dir = catalog_dir/"Artist"/"Album"
    mkdir_p album_dir
    cp test_fixtures("test.wav"), album_dir/"Track01.wav"
    cp test_fixtures("test.wav"), album_dir/"Track02.wav"
    cp test_fixtures("test.jpg"), album_dir/"artwork.jpg"

    output_dir = testpath/"html"
    system bin/"faircamp", "--catalog-dir", catalog_dir, "--build-dir", output_dir

    assert_path_exists output_dir/"favicon.svg"
    assert_path_exists output_dir/"album"/"index.html"
    assert_path_exists output_dir/"album"/"cover_1.jpg"
    assert_path_exists output_dir/"album"/"opus-96"/"ASINtk0hKII"/"01 Track01.opus"
    assert_path_exists output_dir/"album"/"opus-96"/"uWPoxZFX0kQ"/"02 Track02.opus"
    assert_path_exists output_dir/"album"/"mp3-v5"/"1syLQAjRlm8"/"01 Track01.mp3"
    assert_path_exists output_dir/"album"/"mp3-v5"/"zh4GTzy3VT0"/"02 Track02.mp3"
  end
end