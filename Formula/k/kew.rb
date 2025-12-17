class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "e56e01cc199a09c70e15668291ad717c559e9e0809643206c0398602b6b5f5ad"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "6152e233a19babd2e7bc959f2e43a46460aed0919fca605c7a4d4adf35e6350a"
    sha256 arm64_sequoia: "3254acb2861828d6e89271f46758ef442dd5cc22ee6d0cc506fcce49d6f265b3"
    sha256 arm64_sonoma:  "c8a31c90630c09aa599fa5995769beae0b660ff995e6fd5bfbf66c9c4a92cfa3"
    sha256 sonoma:        "0a3d434054fe7ab30f4b55172394ebb7e3d0be6b5d93ed6e44e6cefa129a334f"
    sha256 arm64_linux:   "31bb34851e86876a6280635f9f8fe6474fb4e99a38f605071cce9edce55e0e07"
    sha256 x86_64_linux:  "daf3cdc9ab209997a4fb17ff59751449bb0f0cecf2ce0d2285e5317488e90121"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end