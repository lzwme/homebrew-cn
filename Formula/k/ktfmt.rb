class Ktfmt < Formula
  desc "Kotlin code formatter"
  homepage "https:facebook.github.ioktfmt"
  url "https:github.comfacebookktfmtarchiverefstagsv0.53.tar.gz"
  sha256 "351cd93d8742efaedef800c36b6744d8e7d7abf8558333a92b7747d9a364d530"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c740271696dca6e4ed545c504f6536cce5fdb35c04d0230e446f2218910944"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ccdf6d7763e922206819075a68c913a1eed34a63222630fc23a2825a0cbc524"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7608bc9bb59d410ffb3dc77e00e20f310d532be9a3fd487b24f789123f83c7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "432eb1890dde168f5fe82b7ced7495c15f41d0a83df87e5ba46fcb4c1e9b16a8"
    sha256 cellar: :any_skip_relocation, ventura:       "83f2e2bdac8a0bba0becfbf23bbc2cd859d737b51fa0933203d93e94e86566c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a816945be162cd48325e41ca32c7df91a5f4a08b7742c5c4ea97fa524e4bd3c"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install "coretargetktfmt-#{version}-jar-with-dependencies.jar"
    bin.write_jar_script libexec"ktfmt-#{version}-jar-with-dependencies.jar", "ktfmt"
  end

  test do
    test_file = testpath"Test.kt"
    test_file.write <<~EOS
      fun main() { println("Hello, World!") }
    EOS

    output = shell_output("#{bin}ktfmt --google-style #{test_file} 2>&1")
    assert_match "Done formatting #{test_file}", output
    assert_equal <<~EOS, test_file.read
      fun main() {
        println("Hello, World!")
      }
    EOS
  end
end