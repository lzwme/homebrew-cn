class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.9.2.tar.gz"
  sha256 "15c826e22d8297223ae6c591d14ff79226682ef4db3911a1f349d639406295b7"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c1e5bea71211ec1023a6642cb6e724c4fede822d3e05dfc34b18457c1c1cf34f"
    sha256 cellar: :any, arm64_ventura:  "4700c89421188730e7f10141ad304bc77fed9ca14b3274a5af604365a8bb960e"
    sha256 cellar: :any, arm64_monterey: "087e98915ae8676581e7e6f32c5230279af684885cbce817ce85f88d5dd63ed7"
    sha256 cellar: :any, sonoma:         "c9f9e347b03d917bda3dd5ce772a0108a15ec29af17c4d25dcea2c4cdb2d5326"
    sha256 cellar: :any, ventura:        "22b6b0f5cf4809afab09e9aec1d7f73ab0dab8d9c5f0fa9b1d0cc2d5ffb11715"
    sha256 cellar: :any, monterey:       "28dbad8e63dec63f10e2d3ba96b97a5e561e1c82a6f6518bb0453192ea67ebc6"
  end

  depends_on "opus" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
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
    assert_match "faircamp 0.9.2 (compiled with libvips)", version_str

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