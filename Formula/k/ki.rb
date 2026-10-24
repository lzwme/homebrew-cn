class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://ghfast.top/https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "46404602ca69c18a777ed2c88de5c5eec7e43d4cc1e77a4b44e413701bd327a0"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb730ac6d47ff9ba3b7d1f3813ee1e3d992f2dc5cd3b809cf3984b99fa80e532"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb730ac6d47ff9ba3b7d1f3813ee1e3d992f2dc5cd3b809cf3984b99fa80e532"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb730ac6d47ff9ba3b7d1f3813ee1e3d992f2dc5cd3b809cf3984b99fa80e532"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2133117a4a3345dcce8f8d0a08d3d475fd5ce9cb48d701fcb305c6cf79964194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2133117a4a3345dcce8f8d0a08d3d475fd5ce9cb48d701fcb305c6cf79964194"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21"

  allow_network_access! :build

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")

    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar", "lib/ki-completion-plugin.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki", java_version: "21"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end