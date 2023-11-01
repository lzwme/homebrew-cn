class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/detekt/detekt"
  url "https://ghproxy.com/https://github.com/detekt/detekt/releases/download/v1.23.2/detekt-cli-1.23.2-all.jar"
  sha256 "a02d6cc7e2595bb5d76a2103f40d06dd0a0667518bd886c5bd1c464343f909b2"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3bdb98be0ae9478b03e7fbda02c7ad36638b4091ed2ee8b235ec851fe842ea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3bdb98be0ae9478b03e7fbda02c7ad36638b4091ed2ee8b235ec851fe842ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3bdb98be0ae9478b03e7fbda02c7ad36638b4091ed2ee8b235ec851fe842ea8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3bdb98be0ae9478b03e7fbda02c7ad36638b4091ed2ee8b235ec851fe842ea8"
    sha256 cellar: :any_skip_relocation, ventura:        "e3bdb98be0ae9478b03e7fbda02c7ad36638b4091ed2ee8b235ec851fe842ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "e3bdb98be0ae9478b03e7fbda02c7ad36638b4091ed2ee8b235ec851fe842ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6062ba2a11bd4dcde3cbb94ab8ade7f5edebd94bfde4f07c37975653ff3eab81"
  end

  depends_on "openjdk@17"

  def install
    libexec.install "detekt-cli-#{version}-all.jar"
    # remove `--add-opens` after https://github.com/detekt/detekt/issues/5576
    bin.write_jar_script libexec/"detekt-cli-#{version}-all.jar", "detekt", "--add-opens java.base/java.lang=ALL-UNNAMED", java_version: "17"
  end

  test do
    # generate default config for testing
    system bin/"detekt", "--generate-config"
    assert_match "empty-blocks:", File.read(testpath/"detekt.yml")

    (testpath/"input.kt").write <<~EOS
      fun main() {

      }
    EOS
    shell_output("#{bin}/detekt --input input.kt --report txt:output.txt --config #{testpath}/detekt.yml", 2)
    assert_equal "EmptyFunctionBlock", shell_output("cat output.txt").slice(/\w+/)
  end
end