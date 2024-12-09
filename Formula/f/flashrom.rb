class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https:flashrom.org"
  url "https:download.flashrom.orgreleasesflashrom-v1.5.0.tar.xz"
  sha256 "3ef431cd0f039c1f7b929e81be145885e79192d16a843827e42977f488d9fec5"
  license "GPL-2.0-or-later"
  head "https:review.coreboot.orgflashrom.git", branch: "master"

  livecheck do
    url "https:download.flashrom.orgreleases"
    regex(href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b0b8293a90df12e7bfc1319c7aa695398eb7831f3ef9a20bdb5375d049d4f7dd"
    sha256 cellar: :any, arm64_sonoma:  "e5e649be6e83621c75c7cc60c0385b8a5bbdafd55c85cbe19ae8134e599c9e53"
    sha256 cellar: :any, arm64_ventura: "e5b95420ec57a51fd641b82fc76b254efe8b75dd2286cefdbca818620d139b99"
    sha256 cellar: :any, sonoma:        "87f42e70eca648cfe6e9cc3f677cf643e3cffdb2406ac20e1250fb0fb7d999c7"
    sha256 cellar: :any, ventura:       "39afbd7916ab63b52ecc75a34586b9fece907c3e3283a9eda246fa1a13c10eea"
    sha256               x86_64_linux:  "ac6cdefa587fb69e264dd5ab1e2d0797efc52be5c94895addf23d2cf9ba07c95"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libftdi"
  depends_on "libusb"
  depends_on "openssl@3"

  resource "DirectHW" do
    url "https:github.comPureDarwinDirectHWarchiverefstagsDirectHW-1.tar.gz"
    sha256 "14cc45a1a2c1a543717b1de0892c196534137db177413b9b85bedbe15cbe4563"
  end

  def install
    ENV["CONFIG_RAYER_SPI"] = "no"
    ENV["CONFIG_ENABLE_LIBPCI_PROGRAMMERS"] = "no"

    # install DirectHW for osx x86 builds
    if OS.mac? && Hardware::CPU.intel?
      (buildpath"DirectHW").install resource("DirectHW")
      ENV.append "CFLAGS", "-I#{buildpath}"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin"flashrom", "--version"

    output = shell_output("#{sbin}flashrom --erase --programmer dummy 2>&1", 1)
    assert_match "No EEPROMflash device found", output
  end
end