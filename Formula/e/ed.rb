class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.20.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.20.tar.lz"
  sha256 "c6030defe6ae172f1687906d7354054c75a6a9130af319d4e73c50a91959c5a6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3701638e68cc9d00d09ba4c400433b404561d4fc554f85c7d645694e2d2bdd63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dc1b45533a8c677a5fe846848025d7c9aba530bb92bc5a69e6a700633e1694e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4bd26f96851824a018071083f7f0aba3d09ea616e4a0470a241f77ab20fd70f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a405e3c896baf8587bdfd49b1a65988bcb9b7bff1011b7aca6bcdf30a40ccd41"
    sha256 cellar: :any_skip_relocation, ventura:        "ec94e4eeeccc7aa2e66a80bdcd5a195b764413638d9d7aad62ac06998eaea6ae"
    sha256 cellar: :any_skip_relocation, monterey:       "8b2f03bef02bb37c6476b1fe3429e99b45e7bc71be0f80def935862b1a7ef3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85d76770c2bf7d12f380ea80e7e6e5c7be9bfed4c90c334e3dc95850ad0c926"
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

    libexec.install_symlink "gnuman" => "man"
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