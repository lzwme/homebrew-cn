class Vsd < Formula
  desc "Download video streams over HTTP, DASH (.mpd), and HLS (.m3u8)"
  homepage "https://github.com/clitic/vsd"
  url "https://ghfast.top/https://github.com/clitic/vsd/archive/refs/tags/vsd-0.4.0.tar.gz"
  sha256 "06d76e3456c850c8add63db5c8650dfabafb27879dc3b4c461e1123e950a5fb0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a258a94475f871f437730583deec5741f5c95ea1487ac34fedd4fdd2eb4278a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c1c2fcafd5ca557e7a48fddc2cc093ff0706db5a7a154b1fa224d73f936b9f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd12dc6671679e184c8e6a2ded0cd7d1ad4243c64d166aecdbb5b56f11fd5a88"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c69dd2b6aa6ae5cf1133f240a20231617f91d9e429c34f88a0a74ca1ab5a06e"
    sha256 cellar: :any_skip_relocation, ventura:       "935cdc757a9f8e5df3ae0fb09837a5ea3a3560733058f7de8ffbaeebaf6bdd05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91b99fbb20f7623350fb452be246266fc27896a6df90ccef481a7858d1117ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6652250ce568babbc83646ab97a984c16edbd8096db83d17425ec9429def789c"
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