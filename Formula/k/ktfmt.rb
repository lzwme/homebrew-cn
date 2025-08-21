class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://ghfast.top/https://github.com/facebook/ktfmt/archive/refs/tags/v0.57.tar.gz"
  sha256 "f4948980930ec3b357f45a31cae5cff444638c38285e8c272c20cc01f44d3361"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0bba0dd65835cdcc8b134fe6f0028a9eea32d634cd15fd90505c97d8d2484f0e"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix

    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "core/build/libs/ktfmt-#{version}-with-dependencies.jar"
    bin.write_jar_script libexec/"ktfmt-#{version}-with-dependencies.jar", "ktfmt", java_version: "17"
  end

  test do
    test_file = testpath/"Test.kt"
    test_file.write <<~EOS
      fun main() { println("Hello, World!") }
    EOS

    output = shell_output("#{bin}/ktfmt --google-style #{test_file} 2>&1")
    assert_match "Done formatting #{test_file}", output
    assert_equal <<~EOS, test_file.read
      fun main() {
        println("Hello, World!")
      }
    EOS
  end
end