class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https:ktlint.github.io"
  url "https:github.compinterestktlintreleasesdownload1.4.1ktlint-1.4.1.zip"
  sha256 "16e00d9bfdb5bd86428d75dc9d6901784eac98fd8203e46479ad7c937c2c1afd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d16096d04e8befb57027f07d5e4f5ee9996cb25acbcea705d18af1e592d9b018"
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