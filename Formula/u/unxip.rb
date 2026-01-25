class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://ghfast.top/https://github.com/saagarjha/unxip/archive/refs/tags/v3.3.tar.gz"
  sha256 "490c27aeabad33a8c811ada09008d24835f0f701ad40092b450c4788cdf99198"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6468584b66cbb9fc898632f86528807d8e9f917dea449ba19a0fe8e479923e71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12026ad622e2ae173f53a7543b9a1217535b01e378ab065a2ab21fca946036c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba38a6d9514ec77d66bf7a60edf41b5edcc38761af456e70938dec3d5ddcf142"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9a26db7bac46002402305183fdb36e07b3075499e1437a1f72b4655b5a52b3e"
    sha256                               arm64_linux:   "06a622764d33ba8aca18e76b810332da4069f6a5123de7e2af3fdfa55f6c2e42"
    sha256                               x86_64_linux:  "6d838195777015456ba4e27dd171ebe1dccc444c24f007425b0cc844e2b311aa"
  end

  depends_on macos: :sonoma

  uses_from_macos "swift", since: :sonoma

  on_sequoia :or_older do
    depends_on xcode: ["16.0", :build]
  end

  # Uses Compression framework on macOS
  on_linux do
    depends_on "xz"
    depends_on "zlib"
  end

  def install
    args = %w[--disable-sandbox --configuration release]
    args += %W[-Xcc -I#{HOMEBREW_PREFIX}/include -Xlinker -L#{HOMEBREW_PREFIX}/lib] if OS.linux?

    system "swift", "build", *args
    bin.install ".build/release/unxip"
  end

  test do
    assert_equal "unxip #{version}", shell_output("#{bin}/unxip --version").strip
    # On Linux we don't have `xar` or XAR support in `libarchive`
    return if OS.linux?

    # Create a sample xar archive just to satisfy a .xip header, then test
    # the failure case of expanding to a non-existent directory
    touch "foo.txt"
    system "xar", "-c", "-f", "foo.xip", "foo.txt"
    assert_match %r{^Failed to access output directory at /not/a/real/dir.*$},
      shell_output("2>&1 #{bin}/unxip foo.xip /not/a/real/dir", 1)
  end
end