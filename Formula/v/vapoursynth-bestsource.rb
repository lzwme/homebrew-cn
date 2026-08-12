class VapoursynthBestsource < Formula
  desc "Audio/video source and FFmpeg wrapper"
  homepage "https://github.com/vapoursynth/bestsource"
  url "https://ghfast.top/https://github.com/vapoursynth/bestsource/archive/refs/tags/R20.tar.gz"
  sha256 "e44d84ce80be44f5e65a8daf007fa082af00a2aa81a2f19448acfa6abb49048a"
  license "MIT"
  revision 1
  head "https://github.com/vapoursynth/bestsource.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "624b66a7b6b96836cf29c55dbb5ed554ddd4bb003dfbb4b7d0819b2cbd528f40"
    sha256 cellar: :any, arm64_sequoia: "3356ec4b767395809f81331850efed2b24f3c22b9e03cd4c0a8ee066a05bde04"
    sha256 cellar: :any, arm64_sonoma:  "3a158397750869fe8a5f53ad4a42f6c79a0cde3fe6e5b213d39fdb6d6256d18e"
    sha256 cellar: :any, sonoma:        "754c4f93d6abda14acabd4b19331ac7c08508e3c4e4f2b4fc3777a7360940738"
    sha256               arm64_linux:   "43ca97373669e63342b5e7574a16d270310a621a213fba17cab6c5ed89a6b2d4"
    sha256               x86_64_linux:  "ae5eaa2550915c163fd48ec9e9ee466caee463ea13046bc075cb20b9dcc7e102"
  end

  depends_on "avisynthplus" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "python@3.14"
  depends_on "vapoursynth"
  depends_on "xxhash"

  resource "libp2p" do
    url "https://ghfast.top/https://github.com/sekrit-twc/libp2p/archive/869fa993041f9f3af7d9ac8b10158920c6ddce66.tar.gz"
    sha256 "cacef2683a19a8b288cf567544b507f7f06dd66160db566bf3349e5ee0b73d90"
  end

  deny_network_access!

  def python3 = "python3.14"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    resource("libp2p").stage("subprojects/libp2p")
    (buildpath/"subprojects/libp2p").install "subprojects/packagefiles/libp2p/meson.build"

    # upstream expects a subproject, but we can build with our avisynthplus instead
    avisynth_pc = formula_opt_lib("avisynthplus")/"pkgconfig/avisynth.pc"
    (buildpath/"pkgconfig").install_symlink avisynth_pc => "avisynthplus.pc"
    ENV.append_path "PKG_CONFIG_PATH", buildpath/"pkgconfig"

    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    # Using nodownload as nofallback with `--force-fallback-for` can download HEAD git repos
    system "meson", "setup", "build", *args, *std_meson_args, "--wrap-mode=nodownload"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from vapoursynth import core
      print(core.bs.TrackInfo("#{test_fixtures("test.mp4")}")["codecstr"])
    PYTHON
    assert_equal "h264", shell_output("#{python3} test.py").chomp
  end
end