class Vsd < Formula
  desc "Download video streams over HTTP, DASH (.mpd), and HLS (.m3u8)"
  homepage "https://github.com/clitic/vsd"
  url "https://ghfast.top/https://github.com/clitic/vsd/archive/refs/tags/vsd-0.4.1.tar.gz"
  sha256 "90a23926db4e7ee7a7cda4d233cf87c558fbac81f4c80400effbfbc600ff50e8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3598124be66460ad5b3573367987c6584b2cd54cd8eac0a5ee19ed717c695c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe5410720b44ea54377c6e1fc96af0c2f7a24501d0d6215c3bad3a5c9ece308"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4b4a00cfb89f846127e8fc17086f49743c72b9365892d538e8e101b88ddef7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "475e1a698f39238ddceafe34a848ec4b5f85138f74f4169e6412edbe497a7099"
    sha256 cellar: :any_skip_relocation, ventura:       "29244c10722d714771a1100153d0666f2c6c5de1502e80ca9fb463185fe7b10b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b30745103cd926260b68088d4f2fab949cb3b39d58d0468054af1855ad774e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf0879345a3f7259fa7213445c509ee33dd0e1f48fafccfde3b52edcf9f440b"
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