class Blink < Formula
  desc "Tiniest x86-64-linux emulator"
  homepage "https://github.com/jart/blink"
  url "https://ghproxy.com/https://github.com/jart/blink/releases/download/1.0.0/blink-1.0.0.tar.gz"
  sha256 "09ffc3cdb57449111510bbf2f552b3923d82a983ef032ee819c07f5da924c3a6"
  license "ISC"
  head "https://github.com/jart/blink.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9737aa7c6ba831fb0adc1aa14b8f796f4893b0b0ff6efdb59372970500e8c01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "474607eb69f3bf7e81b075b39bba5aa20894d9ec857ed31feb3b2296ab799061"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e10861418820b3f06a7f53a28af96b8439687cab196dece4a5e563fb3724d9f"
    sha256 cellar: :any_skip_relocation, ventura:        "37aeb4a69f8b0918ab7caec0b93602bf40b06b26df4a1005e9450208b50028fa"
    sha256 cellar: :any_skip_relocation, monterey:       "721816b4dbdf787da513122296049001b1668f63f81085e0feff79ac97d7c4ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "bae386414550cf4546e76681e5d30bdbeb82cfc2079643ae2832d16391dc8e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8e0eab26c1ea0087bcf0e25addd8833323d0fd249db08a808e4b5e363e7dff8"
  end

  depends_on "make" => :build # Needs Make 4.0+
  depends_on "pkg-config" => :build
  uses_from_macos "zlib"

  def install
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    system "./configure", "--prefix=#{prefix}", "--enable-vfs"
    system "make"
    system "make", "install"
  end

  test do
    stable.stage testpath
    ENV["BLINK_PREFIX"] = testpath
    goodhello = "third_party/cosmo/goodhello.elf"
    chmod "+x", goodhello
    system bin/"blink", "-m", goodhello
  end
end