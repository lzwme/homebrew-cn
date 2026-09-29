class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://ghfast.top/https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "5ce3401f2975b330936c0739b62910ae3b193f0d8f323b7b246bb242e1987e19"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "1909626892e6ab14e77b687230dd7c12f549bd358cb1774844789c9ac7685aee"
    sha256 arm64_tahoe:       "269e1324c134dd2fb95f569b328ebac04316875c73117bce8f9a0d9a7dbb7986"
    sha256 arm64_sequoia:     "941909d953d7a72d680423beed8c85122323cd2683c0a5ae84baa668d08b34e3"
    sha256 arm64_linux:       "25995d48a3a0b2e10ba617089f7fe74e327a66a050055081a36c7fc2ba4e5966"
    sha256 x86_64_linux:      "0d9f0d37aab6b30102d9e7205f593b5274e15d41f4ecbed0f5b0f07649bfd865"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "libzip"
  depends_on "mad"
  depends_on "portmidi"
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def doomwaddir(root)
    root/"share/games/doom"
  end

  deny_network_access!

  def install
    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(HOMEBREW_PREFIX)}",
                    "-DDSDAPWADDIR=#{libexec}",
                    "-DSTRICT_FIND=ON",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_MAD=ON",
                    "-DWITH_PORTMIDI=ON",
                    "-DWITH_VORBISFILE=ON",
                    "-DWITH_XMP=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      set -e
      parent="#{HOMEBREW_PREFIX}/share/games"
      if [ -L "$parent" ]; then
        original="$(cd "$parent" && pwd -P)"
        rm "$parent"
        mkdir -p "$parent"
        if [ -d "$original" ]; then
          for child in "$original"/* "$original"/.[!.]* "$original"/..?*; do
            [ -e "$child" ] || [ -L "$child" ] || continue
            ln -s "$child" "$parent/$(basename "$child")"
          done
        fi
      fi
      mkdir -p "$parent/doom"
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    run "post-install", base: :libexec
  end

  def caveats
    <<~EOS
      For DSDA-Doom to find your WAD files, place them in:
        #{doomwaddir(HOMEBREW_PREFIX)}
    EOS
  end

  test do
    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end