class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://ghfast.top/https://github.com/ZerBea/hcxtools/archive/refs/tags/7.0.0.tar.gz"
  sha256 "d5c552ba16b232e203d9e94410dab76def3262c4e3577525332a55e64aac80dd"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3828d2757f6bcd8a3b385e99fa52c9553fcaf72ef3b5ae89d8d8d1c1a338898"
    sha256 cellar: :any,                 arm64_sonoma:  "f7c6079d40740ebd7fa4cfcf5cfb924dc803a7ff4f16f3bf8633f6549064d5fc"
    sha256 cellar: :any,                 arm64_ventura: "b79ab7462f3a342fc5ce7391fef913a6ae1d3d31c220c3a14a8b72883bf22005"
    sha256 cellar: :any,                 sonoma:        "226c6cdcab72e301cd4b396428c4848338e96d0e11af20180b8b9912b371a68a"
    sha256 cellar: :any,                 ventura:       "8fe3f4ee0205dbf611d54b787cc56204f922b5aa9a897d18851a5f86987889f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f68d19c7a620b6ada3304b5a59e6f850c0c925f3ff53c624b50dbf7cd8376790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26013c9a30a7ddc345ffc63a0a57b56f63d0fb8da101ab7fc036ffdb9c78f93e"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Create file with 22000 hash line
    testhash = testpath/"test.22000"
    (testpath/"test.22000").write <<~EOS
      WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***
    EOS

    # Convert hash to .cap file
    testcap = testpath/"test.cap"
    system bin/"hcxhash2cap", "--pmkid-eapol=#{testhash}", "-c", testpath/"test.cap"

    # Convert .cap file back to hash file
    newhash = testpath/"new.22000"
    system bin/"hcxpcapngtool", "-o", newhash, testcap

    expected = "WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***01"
    assert_equal expected, newhash.read.chomp
  end
end