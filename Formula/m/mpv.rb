class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 7
  compatibility_version 1
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/mpv-player/mpv/archive/refs/tags/v0.41.0.tar.gz"
    sha256 "ee21092a5ee427353392360929dc64645c54479aefdb5babc5cfbb5fad626209"

    # Backport support for Vapoursynth 74+
    patch do
      url "https://github.com/mpv-player/mpv/commit/75b2ccfeb1ce4ed5a40ac9860fa74f3d1265e13f.patch?full_index=1"
      sha256 "3906b98b02071a0d5747a400406494ca69cef7afd8d3eee4a99fdbe40dc90c1f"
      type :backport
      resolves "https://github.com/mpv-player/mpv/pull/17731"
    end
  end

  bottle do
    sha256               arm64_tahoe:   "289be87891a6987b5b4922ee39a00198564c3f7b2a142740cf7f4df97d57454d"
    sha256               arm64_sequoia: "f59565de86800fbd05cfdb0e3da387c51dc22c2f199f0410a4510c41557d07e0"
    sha256               arm64_sonoma:  "7e0b2b8fbea7783406d18e8ad732c406db5e0189de68047c47fe751914a0ed2d"
    sha256 cellar: :any, sonoma:        "c9e76039686f3eed7eab81f73c7082849568b0aebab2d93a0cdffaed72b110ee"
    sha256               arm64_linux:   "662a79092d7693d16005516801378ccf88f86cc20c72ea82ad9501ca6728f74f"
    sha256               x86_64_linux:  "21418a4081abf4708668877a1bb8557a9636ebd0dcedc6add0777e6713355989"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libplacebo"
  depends_on "little-cms2"
  depends_on "luajit"
  depends_on "mujs"
  depends_on "rubberband"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "vulkan-loader"
  depends_on "yt-dlp"
  depends_on "zimg"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "libxpresent"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxv"
    depends_on "mesa"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "wayland"
    depends_on "wayland-protocols" => :no_linkage # needed by mpv.pc
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "stolendata-mpv", because: "both install `mpv` binaries"

  def install
    args = %W[
      --sysconfdir=#{etc}
      -Dbuild-date=false
      -Dhtml-build=enabled
      -Djavascript=enabled
      -Dlibmpv=true
      -Dlua=luajit
      -Dlibarchive=enabled
      -Duchardet=enabled
      -Dvulkan=enabled
    ]
    if OS.linux?
      args += %w[
        -Degl=enabled
        -Dwayland=enabled
        -Dx11=enabled
      ]
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    bash_completion.install share/"bash-completion/completions/mpv"

    return unless OS.mac?

    # `pkg-config --libs mpv` includes libarchive, but that package is
    # keg-only so it needs to look for the pkgconfig file in libarchive's opt
    # path.
    libarchive = formula_opt_prefix("libarchive")
    inreplace lib/"pkgconfig/mpv.pc",
              /^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$/,
              "Requires.private:\\1#{libarchive}/lib/pkgconfig/libarchive.pc\\3"
  end

  def caveats
    <<~EOS
      The global configuration directory is now #{pkgetc}/
      You may need to migrate any data in previous #{pkgetc}/mpv/
    EOS
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output("#{bin}/mpv --vf=help")

    # Make sure `pkgconf` can parse `mpv.pc` after the `inreplace`.
    system "pkgconf", "--print-errors", "mpv"
  end
end