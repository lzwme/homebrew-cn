class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://ghfast.top/https://github.com/containers/crun/releases/download/1.30/crun-1.30.tar.zst"
  sha256 "a42d428c63100c206becafa6ddf423aeb151c8829dc8c957d868664255c11e4e"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any, arm64_linux:  "dcd68ea7cf231828e64976dd43b34b91dccf10127c052605afe236cf7394a0c6"
    sha256 cellar: :any, x86_64_linux: "e66f8ceb9fba2a8dfe88697ca8d11a952d3a93b6b8a41a3f9d75a7b71e76ac29"
  end

  head do
    url "https://github.com/containers/crun.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build

  depends_on "json-c"
  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}/crun --root=#{testpath} list -q").strip
  end
end