class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.15.0.tar.gz"
  sha256 "cdb2db74a517e421b156b8512b11a26de1bfb433cb237d743856e6c744df1fd1"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c3fef8b152d3023fb03973675633f98cdf582bf353d9b0118f85995b457f7cd1"
    sha256 cellar: :any, arm64_ventura:  "2f13a11496a1764c23099fc699656b59efe7efa0e80d19d624844f788479ad9f"
    sha256 cellar: :any, arm64_monterey: "332dcf3568a23d6785616a2e0f021b052c686dbbb024a29a22ef6be4cd11f3b9"
    sha256 cellar: :any, sonoma:         "ec3f896c2b5a16b6200cff4d3597384058f755fee22f3bb6143b3e0b40a16698"
    sha256 cellar: :any, ventura:        "9c656a1c7fe155cfada03e2113adde3de9a211b10ced79f9be206a312826777d"
    sha256 cellar: :any, monterey:       "e8ea58b38689d5f7400bc027ed9abf12728df101556d85d5744dd8a9d7013dea"
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