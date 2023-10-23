class ProtobufAT3 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://ghproxy.com/https://github.com/protocolbuffers/protobuf/releases/download/v3.20.3/protobuf-all-3.20.3.tar.gz"
  sha256 "acb71ce46502683c31d4f15bafb611b9e7b858b6024804d6fb84b85750884208"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "1317a629eb55bbd416853120a4bd50744b32bcca09d2f1caed3f5360e3e4f2a7"
    sha256 cellar: :any,                 arm64_ventura:  "a2dfe23502baad6bebe06b5f717f1d5793b80a97f74232abf1a2714327c6f46e"
    sha256 cellar: :any,                 arm64_monterey: "8241c19b8ebcebbba0d0137c874272de92dbdfc39fbc74b6e38be2931b98fe1d"
    sha256 cellar: :any,                 sonoma:         "c3b745078511d00fc786087fd40b98c625bb779114d039baedb06fb2aa55ae6f"
    sha256 cellar: :any,                 ventura:        "f5f633de1d7c2be6aac8fca1108bc82c9839d612b702d667ed232760afa19755"
    sha256 cellar: :any,                 monterey:       "a943f5ff7a6f399184755c8c04c98f1b13b67ea053286351d917b6283272a4a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03170e3cfce63db4497090cb83bec5060e54517d4db07fdde634981ca316666d"
  end

  keg_only :versioned_formula

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "zlib"

  # Backport support for Python 3.11
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/da973aff2adab60a9e516d3202c111dbdde1a50f.patch?full_index=1"
    sha256 "911925e427a396fa5e54354db8324c0178f5c602b3f819f7d471bb569cc34f53"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--with-zlib", "--with-pic"
    system "make"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    cd "python" do
      pythons.each do |python|
        system python, *Language::Python.setup_install_args(prefix, python), "--cpp_implementation"
      end
    end
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
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."

    pythons.each do |python|
      with_env(PYTHONPATH: prefix/Language::Python.site_packages(python)) do
        system python, "-c", "import google.protobuf"
      end
    end
  end
end