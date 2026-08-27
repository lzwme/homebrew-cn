class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-5.1.1.zip"
  sha256 "51a5a86c638abc618273f9f318ad2d906fcd4fecbdc1b9fa3c9f47c8c3cd753b"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4ba2108f99146e62141d3f3d412442713357f3cd25b402fa4eabcefacdb7a3d"
  end

  depends_on "openjdk"

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    libexec.install "conf", "lib"

    buildpath.glob("bin/*").each do |f|
      next if f.extname == ".bat"
      next if f.extname == ".ico"
      next if f.basename.to_s.end_with?("_completion")

      bin.install f
    end

    env = Language::Java.overridable_java_home_env
    env["GROOVY_HOME"] = "${GROOVY_HOME:-#{libexec}}"
    bin.env_script_all_files libexec/"bin", env

    buildpath.glob("bin/*.ico").each { |f| (libexec/"bin").install f }
    buildpath.glob("bin/*_completion").each { |f| bash_completion.install f => File.basename(f, "_completion") }
  end

  test do
    output = shell_output("#{bin}/grape install org.activiti activiti-engine 5.16.4")
    assert_match "found org.activiti#activiti-engine;5.16.4", output
    assert_match "65536", pipe_output("#{bin}/groovysh", "println 64*1024\n:exit\n")
  end
end