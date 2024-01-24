class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.11.0.tar.gz"
  sha256 "189361bd0d586e782990d48b1a2bfda5507091db7a28e119b1dc514ffdd9fca1"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "64598a3eecde219ce7f80abd4bb8f9d110e1653a506e89029427dcd0888e10a7"
    sha256 cellar: :any, arm64_ventura:  "ca91a79cec3edb7476f8a4838408e98af48b5ed68890b746cc82987face33988"
    sha256 cellar: :any, arm64_monterey: "811809b473d3c3df482b65e544de4b450f793a567d73d6efc5e106320c34ccdb"
    sha256 cellar: :any, sonoma:         "fb2768fffd7161bed090853304e5b332254a2e1a7b5e37b7d42fddaaf161047c"
    sha256 cellar: :any, ventura:        "46d7d6845fd43172a5452d9aa3bb7ea9e33548b8291b8220fea9f48d176520ec"
    sha256 cellar: :any, monterey:       "46aea567379a612afb69df0a13048d2ea8f918bd5db89470cdeb8138439278b7"
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