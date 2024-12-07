class WoofDoom < Formula
  desc "Woof! is a continuation of the BoomMBF bloodline of Doom source ports"
  homepage "https:github.comfabiangreffrathwoof"
  url "https:github.comfabiangreffrathwoofarchiverefstagswoof_15.0.1.tar.gz"
  sha256 "0c8b9652ff415915c76935705369bcd3fbce018aef94976a01122d66e55a801f"
  license "GPL-2.0-only"
  head "https:github.comfabiangreffrathwoof.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3375e598803e3e5a63697215477582405b6e30d559492530b79a94d3889cc97f"
    sha256 cellar: :any,                 arm64_sonoma:  "c3b927a2f701f2b9dbc456e6ed66c50b73a40f58bfde279d0002805eeffcbaac"
    sha256 cellar: :any,                 arm64_ventura: "fefc39a0a4b5b4bb9bc2824ed8f34343fa04f1b802113387d688e3045a949aca"
    sha256 cellar: :any,                 sonoma:        "0f45620e382d8695ba72fc0954e5d2a7399a62fd40922208e1db4af300ebf754"
    sha256 cellar: :any,                 ventura:       "c3554f43f9e6185ca60780a4b445496829e035af73c40cd72a1b5c09cfa6ea26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408affbddfa7cede413fe6e116284affdec68b102eb26188c319c3d24d92cf25"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libebur128"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl2"
  depends_on "sdl2_net"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "woof", because: "both install `woof` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath"test_invalid.wad").write testdata

    expected_output = "Error: Failed to load test_invalid.wad"
    assert_match expected_output, shell_output("#{bin}woof -nogui -iwad test_invalid.wad 2>&1", 255)

    assert_match version.to_s, shell_output("#{bin}woof -version")
  end
end