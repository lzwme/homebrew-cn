class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https:github.comdetektdetekt"
  url "https:github.comdetektdetektreleasesdownloadv1.23.7detekt-cli-1.23.7-all.jar"
  sha256 "84beded283012cb2b38bcaef4996452fcd6069d2e9ca74b50eaa79e0ad21897e"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e1b95136ece72d7559159bf400ec0ee770b41e907bfe6af4427cf115a445583"
  end

  depends_on "openjdk@17"

  def install
    libexec.install "detekt-cli-#{version}-all.jar"
    # remove `--add-opens` after https:github.comdetektdetektissues5576
    bin.write_jar_script libexec"detekt-cli-#{version}-all.jar", "detekt", "--add-opens java.basejava.lang=ALL-UNNAMED", java_version: "17"
  end

  test do
    # generate default config for testing
    system bin"detekt", "--generate-config"
    assert_match "empty-blocks:", File.read(testpath"detekt.yml")

    (testpath"input.kt").write <<~EOS
      fun main() {

      }
    EOS
    shell_output("#{bin}detekt --input input.kt --report txt:output.txt --config #{testpath}detekt.yml", 2)
    assert_equal "EmptyFunctionBlock", shell_output("cat output.txt").slice(\w+)
  end
end