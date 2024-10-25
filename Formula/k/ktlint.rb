class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https:ktlint.github.io"
  url "https:github.compinterestktlintreleasesdownload1.4.0ktlint-1.4.0.zip"
  sha256 "2b0ac5e1eb030627e4c8b634c3a99cc967e483b0e98da7ad05b3ebf399c42684"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "700f4134ab785ca91b68faf1ba45233a4d1bf80cbfb31d1438d2f808ea5167dd"
  end

  depends_on "openjdk"

  def install
    libexec.install "binktlint"
    (libexec"ktlint").chmod 0755
    (bin"ktlint").write_env_script libexec"ktlint", Language::Java.java_home_env
  end

  test do
    (testpath"Main.kt").write <<~EOS
      fun main( )
    EOS
    (testpath"Out.kt").write <<~EOS
      fun main()
    EOS
    system bin"ktlint", "-F", "Main.kt"
    assert_equal shell_output("cat Main.kt"), shell_output("cat Out.kt")
  end
end