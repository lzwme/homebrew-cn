class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https:github.comdetektdetekt"
  url "https:github.comdetektdetektreleasesdownloadv1.23.4detekt-cli-1.23.4-all.jar"
  sha256 "2b1e88d297bb433e093197814557646bac1fa0bf6e4206630941889d925e00e0"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b69f5498220bb83e144a830bd9745584409306e0fff15d16e4bf7c1609be565"
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