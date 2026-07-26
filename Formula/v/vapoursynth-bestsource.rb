class VapoursynthBestsource < Formula
  desc "Audio/video source and FFmpeg wrapper"
  homepage "https://github.com/vapoursynth/bestsource"
  url "https://ghfast.top/https://github.com/vapoursynth/bestsource/archive/refs/tags/R20.tar.gz"
  sha256 "e44d84ce80be44f5e65a8daf007fa082af00a2aa81a2f19448acfa6abb49048a"
  license "MIT"
  head "https://github.com/vapoursynth/bestsource.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff9f173e184757520863933ece6f30c76f5e824a8c43140ea07eaaf25c09db11"
    sha256 cellar: :any, arm64_sequoia: "abf3087114f317a2bd33d7f1863bf06524c4a96953893dcddc76257b7a2f8091"
    sha256 cellar: :any, arm64_sonoma:  "f3113a9abbe83aba967ce0f7172225c4d3d7518e892fd254a47bccf0cbee2a60"
    sha256 cellar: :any, sonoma:        "457cc7ea98b70c2293b75547b348fa4cb4f1561ab0f948bc831d189ab69b2f35"
    sha256               arm64_linux:   "a9f6826364b8d341a6254e4fafa96621549c1e314e66e56554abb0520b71ead5"
    sha256               x86_64_linux:  "5588b715c3be40662f0f3a9630bb76638f6ce08a2ffa843a81a04cf7cb0e19d5"
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