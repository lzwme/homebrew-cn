class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.22.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.22.tar.lz"
  sha256 "7eb22c30a99dcdb50a8630ef7ff3e4642491ac4f8cd1aa9f3182264df4f4ad08"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d8ed15c1a3d3322494f441c052bcc16bc5227a81c5b84292ca7adf91892b23e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e03e7a494a1d1f60bcaf23a4ab03be0d957f0a2af782ca338fb7fad8fd4d36fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f451029ad6aa1f782ec7b3bedc6c94a223eadb4fb72b207d16d025b611ccf8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b61360fe74b4097e2f3f803c4beec5d95ede062a6648c86d648d36d57fda0e"
    sha256 cellar: :any_skip_relocation, ventura:       "22cb9e30a15306fca73571d2fb8ee4e382aac47027cd7777eab9c050c2cfc251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8e266179ed3b544911a6d8476d43b766aed6165b645924ca42d3097fbfefddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e5ad587e6f73297bf58e162f6185a07c5726aa3b20246d48257df01d4c3289"
  end

  keg_only :provided_by_macos

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"

    if OS.mac?
      %w[ed red].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    testfile = testpath/"test"
    testfile.write "Hello world\n"

    if OS.mac?
      pipe_output("#{bin}/ged -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read

      pipe_output("#{opt_libexec}/gnubin/ed -s #{testfile}", ",s/l//g\nw\n", 0)
      assert_equal "He word\n", testfile.read
    else
      pipe_output("#{bin}/ed -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read
    end
  end
end