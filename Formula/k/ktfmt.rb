class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https://facebook.github.io/ktfmt/"
  url "https://ghfast.top/https://github.com/facebook/ktfmt/archive/refs/tags/v0.60.tar.gz"
  sha256 "b17647663bee46b528b8c80c38e241cb7c3d6fea896366dad408ecfed04bccc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ae2b403369d88c3fb123faddcde7b20477ecd19c9a4bc224a8d5c9df891cb01"
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