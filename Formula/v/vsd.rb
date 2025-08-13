class Vsd < Formula
  desc "Download video streams over HTTP, DASH (.mpd), and HLS (.m3u8)"
  homepage "https://github.com/clitic/vsd"
  url "https://ghfast.top/https://github.com/clitic/vsd/archive/refs/tags/vsd-0.4.2.tar.gz"
  sha256 "edc3ffc310a90e8941e6bb48f56e057cefad763104edc3a174caa48206d43e11"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccdae4c5daf9c63de0d3b9bc284b6e5c2a625ab4215f9057c1ef788de2c767cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b338047844c9abb3e63b2f6c50d8df46a989a138ad492ea76a3e4228d6dac0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2643809f7abe434e1eee2c3927d4db42a56bed296dde05dc06c7b3e065ddbdb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "66081014580e637deec52d99c035c58c80b5be51d0fea63c3edc8ee41d3f8125"
    sha256 cellar: :any_skip_relocation, ventura:       "bd013e83cdd359c2aa8b366736c44522324b0e6fd66b482bca7d71069bee863c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627e1a3b2c24654c91abf140fcc801e5eac15698122f2ec9355645c3d217058f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c89ff0bde28984d99a53b82dcd3870399d06d34e827b554f562b9608379d84"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    inreplace "vsd/Cargo.toml" do |s|
      s.gsub! ", path = \"../mp4decrypt\"", ""
      s.gsub! ", path = \"../vsd-mp4\"", ""
    end

    system "cargo", "install", *std_cargo_args(path: "vsd")
  end

  test do
    test_url = "http://maitv-vod.lab.eyevinn.technology/VINN.mp4/master.m3u8"
    output = testpath/"sample.mp4"

    system bin/"vsd", "save", test_url, "-o", output
    assert_path_exists output
    assert_operator output.size, :>, 0
  end
end