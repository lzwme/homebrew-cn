class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://ghfast.top/https://github.com/zhlynn/zsign/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "cf6763be9bbce3a64d34d6bce8a36232af6353b02640ef0ae12b7b8dfd6c54fa"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea393ea61e676a97fea6b19e634adcacc631fbd29b50568b54270b8848d20157"
    sha256 cellar: :any, arm64_sequoia: "6b5d637765e6655f2c2b46a99221b45a28942ecc2ffe23d88a3f60cee91df7a2"
    sha256 cellar: :any, arm64_sonoma:  "ce0e8fedf3c01bed08d6f7167f2edf89b54975c00b68487ca33d8cdcd87bf637"
    sha256 cellar: :any, sonoma:        "30d3df1673af0273d7cbc858aed363ea8e9abda11d138b7072931a8046023fd2"
    sha256 cellar: :any, arm64_linux:   "75d5ba5d121c799b2b8adca4e45d13bb1c3d0e87fe1b7563197293d84ae10f10"
    sha256 cellar: :any, x86_64_linux:  "be3e6a177207c914ea725c1a3bfd1191149084aab8821f4d1cde0b4550988ab4"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Link zlib: metadata.cpp uses it directly but the SYSTEM_MINIZIP path omits -lz.
  patch do
    url "https://github.com/zhlynn/zsign/commit/3372a54c813a50341d725425df55bef1880c566a.patch?full_index=1"
    sha256 "ea76695035284633cfd6906f55669c501318b5b3bb973d1798324f32f90f204c"
    type :unofficial
    resolves "https://github.com/zhlynn/zsign/pull/405"
  end

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    system "make", "-C", build_dir, "CXX=#{ENV.cxx}", "VERSION=#{version}", "SYSTEM_MINIZIP=ng"
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end