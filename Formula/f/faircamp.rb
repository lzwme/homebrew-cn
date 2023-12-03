class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.11.0.tar.gz"
  sha256 "dc92b9fd78e9e791f5fecd97a11690dc61b06af9168967c0f15d4db38c3c7dc5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5d9f9dfca7b77de6fa21debec7c80c30900a9a775af41a0d9f62a6fd980e360a"
    sha256 cellar: :any, arm64_ventura:  "321530d9ae50d1d6d14a1ff9febd3b3e80e9667466cad02514eaa4b5511b15ce"
    sha256 cellar: :any, arm64_monterey: "d524f9c2bd7cbe74b8eacbab9cc2735b20cd38322840e7067ae90a01a03a1ebc"
    sha256 cellar: :any, sonoma:         "08ffdd4b22cfba8a0f43b7f182753128255b3ba7362ef367d4b75f6ec4b4e4fa"
    sha256 cellar: :any, ventura:        "4e3a3643c55fb83ac0225232f8d6c11ba38e587864d9829bdb7601df19611238"
    sha256 cellar: :any, monterey:       "01c01ad04e6c1404f829a8af347f5b2dc30800b054836192d00da291ee041719"
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