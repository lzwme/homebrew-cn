class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.2.0.tar.gz"
  sha256 "4aecd8ea0b9a975fd8880ac75829d3f8611abd853a0bf40512b7e8cec450d2c8"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "bbdd3d54344268377c388af5c043920fe78ced6e0b647ff20e3bd33a2364b1bd"
    sha256 cellar: :any, arm64_sonoma:  "d4c7d3655cb5927bf065322af0f851e8f766dfe0b9da0a9fe6d675bee952f41f"
    sha256 cellar: :any, arm64_ventura: "b0fb2eeeb9b76f212c34312d5ceba0780373f686e6f6d4f4fbb13ed983664d69"
    sha256 cellar: :any, sonoma:        "db5653355b984de39d47e19cd85c4dc1da0e509657f505355e4cba4750f0249e"
    sha256 cellar: :any, ventura:       "bd7f5330d2eeffd884c7fb2c4aa6d85821e7673e993c685edde3670294a8e327"
  end

  depends_on "opus" => :build
  depends_on "pkgconf" => :build
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
    ENV["RUSTFLAGS"] = Utils.safe_popen_read("pkgconf", "--libs", "vips").chomp
    system "cargo", "install", *std_cargo_args, "--features", "libvips"
  end

  test do
    # Check properly compiled with optional libvips feature
    version_str = shell_output("#{bin}/faircamp --version").chomp
    assert_match "faircamp #{version} (compiled with libvips)", version_str

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