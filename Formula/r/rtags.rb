class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://ghfast.top/https://github.com/Andersbakken/rtags/releases/download/v2.44/rtags-2.44.tar.bz2"
  sha256 "3db5b36216e0b0a98fa7ad1e03a29b2ca7c9d895d85dbe3b2760fcdc2f962db3"
  license "GPL-3.0-or-later"
  head "https://github.com/Andersbakken/rtags.git", branch: "master"

  # The `strategy` code below can be removed if/when this software exceeds
  # version 3.23. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v3.23"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6337955889369da13644acf9bcd8863971f8623d0e20a7d87c5436d562bd9eab"
    sha256 cellar: :any, arm64_sequoia: "40490a57292e202e01ecfce447acfe5bb985c128df4ac1c6302a7ea7689ae7c6"
    sha256 cellar: :any, arm64_sonoma:  "e0bc34735908234eba526ae618b315a267405d7447ee978f85dbe51f20fe3ee7"
    sha256 cellar: :any, sonoma:        "a9315e7fee3492ede17de0566fad7f08ef9a455a2bc045782156913ac183b648"
    sha256               arm64_linux:   "f907fbf7277ff32b9d4d829453dda22267c89ed2da2422e8f9face99c956b447"
    sha256               x86_64_linux:  "17bc4d956d77efcf2121f9d55bf4b479c0761eaf7c73de361134adfc5e8b5b2c"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"rdm", "--verbose", "--inactivity-timeout=300"]
    keep_alive true
    log_path var/"log/rtags.log"
    error_log_path var/"log/rtags.log"
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<~C
      void zaphod() {
      }

      void beeblebrox() {
        zaphod();
      }
    C
    (testpath/"src/README").write <<~EOS
      42
    EOS

    rdm = spawn "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log", [:out, :err] => File::NULL
    begin
      sleep 5
      sleep 10 if OS.mac? && Hardware::CPU.intel?
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 5
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system bin/"rc", "-q"
    ensure
      Process.kill "TERM", rdm
      Process.wait rdm
    end
  end
end