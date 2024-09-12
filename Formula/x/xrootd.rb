class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https:xrootd.slac.stanford.edu"
  url "https:github.comxrootdxrootdreleasesdownloadv5.7.1xrootd-5.7.1.tar.gz"
  mirror "https:xrootd.slac.stanford.edudownloadv5.7.1xrootd-5.7.1.tar.gz"
  sha256 "c28c9dc0a2f5d0134e803981be8b1e8b1c9a6ec13b49f5fa3040889b439f4041"
  license "LGPL-3.0-or-later"
  head "https:github.comxrootdxrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6f064bb1a14090ec299fbb32d1397525ddd404906f095160e5fcbe61af7a2175"
    sha256 cellar: :any,                 arm64_sonoma:   "1cfa2fc1ff0ebad0cbfe38df244b8e4eeb87250713d4b71d8198bb9f3a4295cd"
    sha256 cellar: :any,                 arm64_ventura:  "e5d71d8ed09ae5ebbb298e5f389869aee496b98f5a4aa94cf5450acc4b15a785"
    sha256 cellar: :any,                 arm64_monterey: "486b7cb879041150c1726a4c66985836fb88505bb7d93f632594b528616a585b"
    sha256 cellar: :any,                 sonoma:         "c226725a66faed25ecc68277059b4945673d9094dccebea96d4c1b0ac61b0487"
    sha256 cellar: :any,                 ventura:        "7db43c6a1e7d8acb07fe034386166e7c089dbbca22911f08e9624bf8827debfa"
    sha256 cellar: :any,                 monterey:       "e31cafecad553734124cde7c05ece3bfd08956b342ded3be1e47739d2258ae2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "211ed9352c365baee1dad172d8c8c2fd2445cd8a8b24ae996019b87ffbcd2d55"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPython_EXECUTABLE=#{which("python3.12")}
      -DENABLE_READLINE=ON
      -DENABLE_SCITOKENS=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_VOMS=OFF
      -DENABLE_XRDCL=ON
      -DENABLE_XRDCLHTTP=ON
      -DENABLE_XRDEC=OFF
      -DXRDCL_LIB_ONLY=OFF
      -DXRDCL_ONLY=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}xrootd -v 2>&1")

    system "python3.12", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end