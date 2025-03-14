class F2c < Formula
  desc "Fortran to C translator"
  homepage "https://www.netlib.org/f2c/"
  url "http://deb.debian.org/debian/pool/main/f/f2c/f2c_20240504.orig.tar.xz"
  sha256 "12a129a1a8d9a1446f29c0a126b29e8d6a3537266921ad1851bda9933b08221b"

  livecheck do
    url "https://salsa.debian.org/debian/f2c.git"
    strategy :git do |tags|
      tags.filter_map { |tag| tag.split("/", 2)[1].split("-", 2)[0] }
    end
  end

  depends_on "libf2c"

  def install
    # f2c executable
    cd "src" do
      system "make", "-f", "makefile.u", "f2c"
      bin.install "f2c"
    end

    # man pages
    man1.install "f2c.1t"

    # PDF doc
    doc.install "f2c.pdf"
  end

  test do
    # check if executable doesn't error out
    system bin/"f2c", "--version"

    # hello world test
    (testpath/"test.f").write <<~EOS
      C comment line
            program hello
            print*, 'hello world'
            stop
            end
    EOS
    system bin/"f2c", "test.f"
    assert_path_exists (testpath/"test.c")
    system ENV.cc.to_s, "-O", "-o", "test", "test.c", "-I#{Formula["libf2c"].opt_include}",
"-L#{Formula["libf2c"].opt_lib}", "-lf2c"
    assert_equal " hello world\n", `#{testpath}/test`
  end
end