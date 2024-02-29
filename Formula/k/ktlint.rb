class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https:ktlint.github.io"
  url "https:github.compinterestktlintreleasesdownload1.2.0ktlint-1.2.0.zip"
  sha256 "30914b70c5e749af17f5624d793c6ab355048601c08fefc30f54ce6e61dcb7cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75b39c0779573aa22ac386798d91c924b36cf58d249aebdefe7ecb366d900704"
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