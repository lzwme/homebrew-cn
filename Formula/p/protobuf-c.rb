class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https:github.comprotobuf-cprotobuf-c"
  url "https:github.comprotobuf-cprotobuf-creleasesdownloadv1.5.0protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72fee94793c602ef83a4d8aac7d1caa98e133fa6c5f25fbc1d8396579029ef98"
    sha256 cellar: :any,                 arm64_ventura:  "75bb825db8bd2d82af93a89f5f6a9cfe12b6b5d4f6b70341fb155461b2ea552f"
    sha256 cellar: :any,                 arm64_monterey: "8e0115bd2a6b2620d3479a6fd1d20d17cfda41d086b9ab2b030409f0f7a5421d"
    sha256 cellar: :any,                 sonoma:         "88ff05c990ed1e11bb8caeae0064d08c47647ab17f40d956b86be42aaa35c8e8"
    sha256 cellar: :any,                 ventura:        "095c877e564e511a3ef901a64f868dafe47d79f0a825d2f35328a413889e1559"
    sha256 cellar: :any,                 monterey:       "cce6a68c711e9b9526c560edeaacd9a64bae5f22800e72612162239858bfac84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55519392277fdfed903aceed44f4fada89f540399e9bb4e49b9d010b99448380"
  end

  head do
    url "https:github.comprotobuf-cprotobuf-c.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # Apply commits from open PR to support Protobuf 26.
  # PR ref: https:github.comprotobuf-cprotobuf-cpull711
  patch do
    url "https:github.comprotobuf-cprotobuf-ccommite3acc96ca2a00ef715fa2caa659f677cad8a9fa0.patch?full_index=1"
    sha256 "3b564a971023d127bb7b666e5669f792c94766836ccaed5acfae3e23b8152d43"
  end
  patch do
    url "https:github.comprotobuf-cprotobuf-ccommit1b4b205d87b1bc6f575db1fd1cbbb334a694abe8.patch?full_index=1"
    sha256 "6d02812445a229963add1b41c07bebddc3437fecb2a03844708512326fd70914"
  end
  patch do
    url "https:github.comprotobuf-cprotobuf-ccommitd95aced22df60a2f0049fc03af48c8b02ce4d474.patch?full_index=1"
    sha256 "7aa44807367a4547bd15b3aa9a5275d5fe4739348bf2741ca773fa47015fb01a"
  end

  def install
    # https:github.comprotocolbuffersprotobufissues9947
    ENV.append_to_cflags "-DNDEBUG"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath"test.proto").write testdata
    system Formula["protobuf"].opt_bin"protoc", "test.proto", "--c_out=."
  end
end