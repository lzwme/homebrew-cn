class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.12.0.tar.gz"
  sha256 "4e2ecc67cc6e76f4176ba998eda9945c1570b568089709a8290deaa921f66686"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1a20eaa57d20be1fe8d98caa2fcf3fba6218d78c6ffa7db980666e6774f03462"
    sha256 cellar: :any, arm64_ventura:  "aebd667c49a34e4bd27c00992d504625c5c8ab6253843d3e3db523e6a9ffee8f"
    sha256 cellar: :any, arm64_monterey: "c4f25d56ddfbc5a990e1cc78b537fa886e5a12690a564f0887651a3dffdb0c5a"
    sha256 cellar: :any, sonoma:         "dca6120b3cdf9ff31fbbdd9ca11e067915e302e12eaf32b03f0735cd7395c75f"
    sha256 cellar: :any, ventura:        "843621205f3093ab1ffe0631b6d5b6e054fa992bf12fe88ce421630e7951c639"
    sha256 cellar: :any, monterey:       "8869f0ce03efe5f2cbcce95e2a2d5d869c19b55d822165d144f61d8e84a67a85"
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