class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https:ammonite.io"
  url "https:github.comcom-lihaoyiAmmonitereleasesdownload3.0.0-M23.3-3.0.0-M2"
  version "3.0.0-M2"
  sha256 "57b4e3812123861e2acf339c9999f6c23fe2fc4dbfd2c87dc5c52c31bdc37d73"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(^v?(\d+(?:\.\d+)+[._-]M\d)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6b8e2cf8e1bf5d08e9161c5b67bc205d8b8d93d955e1fc32ba60171df8395863"
  end

  depends_on "openjdk"

  def install
    (libexec"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec"binamm"
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOMEbin:$PATH"
    (bin"amm").write_env_script libexec"binamm", env
  end

  test do
    (testpath"testscript.sc").write <<~EOS
      #!usrbinenv amm
      @main
      def fn(): Unit = println("hello world!")
    EOS
    output = shell_output("#{bin}amm #{testpath}testscript.sc")
    assert_equal "hello world!", output.lines.last.chomp
  end
end