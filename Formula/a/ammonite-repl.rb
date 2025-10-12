class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  url "https://ghfast.top/https://github.com/com-lihaoyi/Ammonite/releases/download/3.0.3/3.3-3.0.3"
  version "3.0.3"
  sha256 "454bebe1ccd81a228c8bab24e8a5b5f2a06b179da2e8b4a199366f530279d297"
  license "MIT"

  # There can be a gap between when a GitHub release is created and when the
  # release assets are uploaded, so the `GithubLatest` strategy isn't
  # sufficient here. This checks GitHub asset URLs on the homepage, as it
  # doesn't appear to be updated until the release assets are available.
  livecheck do
    url :homepage
    regex(%r{href=.*?/releases/download/v?(\d+(?:\.\d+)+(?:[._-]M\d+)?)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e6250d477489f3dd87bbef163c0b1e5d15be310c2f4c2228d355bde2df1e02e"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec/"bin/amm"
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"amm").write_env_script libexec/"bin/amm", env
  end

  test do
    (testpath/"testscript.sc").write <<~SCALA
      #!/usr/bin/env amm
      @main
      def fn(): Unit = println("hello world!")
    SCALA
    output = shell_output("#{bin}/amm #{testpath}/testscript.sc")
    assert_equal "hello world!", output.lines.last.chomp
  end
end