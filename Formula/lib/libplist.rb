class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https:www.libimobiledevice.org"
  url "https:github.comlibimobiledevicelibplistreleasesdownload2.6.0libplist-2.6.0.tar.bz2"
  sha256 "67be9ee3169366589c92dc7c22809b90f51911dd9de22520c39c9a64fb047c9c"
  license "LGPL-2.1-or-later"
  head "https:github.comlibimobiledevicelibplist.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6b9ece7854f6db7fcaf6beaf043d83cd1f3dbe54c1208d5ebbd4be56ecc45e05"
    sha256 cellar: :any,                 arm64_ventura:  "65565f4500012d7d9e9930f27f5dd267a841fc10cf762c51a349ece86c9f3e4f"
    sha256 cellar: :any,                 arm64_monterey: "ad1f58b4285197664514657ff118180773884f6de14f2c77031440f01297d2e1"
    sha256 cellar: :any,                 sonoma:         "1c3804cd5d0ffbc2c9e694609e889e0b26d7a87ce98ba5a884bb8c6406ecb59c"
    sha256 cellar: :any,                 ventura:        "c564322af66d7fc3edc4c7253f98785d203442ae5ca7402385d17f46caecffcf"
    sha256 cellar: :any,                 monterey:       "e836a4889c978fc1e799e6727c0e8776e93a5982637c99e72465f3f99983f27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1391edc27beba3ffd60197bcc649c13a2f42808e5b9dd0c9614438a457c4ad73"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    args = %w[
      --disable-silent-rules
      --without-cython
    ]

    system ".autogen.sh", *std_configure_args, *args if build.head?
    system ".configure", *std_configure_args, *args if build.stable?
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-AppleDTD PLIST 1.0EN" "http:www.apple.comDTDsPropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label<key>
        <string>test<string>
        <key>ProgramArguments<key>
        <array>
          <string>binecho<string>
        <array>
      <dict>
      <plist>
    EOS
    system bin"plistutil", "-i", "test.plist", "-o", "test_binary.plist"
    assert_predicate testpath"test_binary.plist", :exist?,
                     "Failed to create converted plist!"
  end
end