class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.22.1.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.22.1.tar.lz"
  sha256 "1af541116796d6b9e4b66ef9c45ddce0e15a19ed62bfca362ccd7d472cc1c8fb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18746c41560122bb5a23d5849d87b7f6b79d9820a50265cb3dca9895cdf05e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "670b8167d95a4e883e7dac04c9ba64ea11eb30dd3cb37450685a72876b7f8125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8b9211eabb1063adf76aa4c5f3ce274efcb96d2d166a222b4eecdef824ae49b"
    sha256 cellar: :any_skip_relocation, sonoma:        "518fc5b4a453456c0d62ff4e3f8c3991b7d934dbed17c18257bc78aba47fe7a7"
    sha256 cellar: :any_skip_relocation, ventura:       "41cfca311709526dd20a2b4dae4fb6dc2f11f540f526f3b8aedd04f34a2da6d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917b72d06a10f07842977f69f45cb051f2c270997f4e47ad1b68109a20a56d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c61b2f73ece5f319d6fc02625416a4a4845440d8bf74bd6d47956556b21b379"
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