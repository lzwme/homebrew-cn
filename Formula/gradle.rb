class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.0.2-all.zip"
  sha256 "47a5bfed9ef814f90f8debcbbb315e8e7c654109acd224595ea39fca95c5d4da"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "66be180af20d99e9b1c87a052e4ad2ee50761ada5c5aa2240bf02b1bad68ef0e"
  end

  # TODO: Switch to `openjdk` on 8.2 release. 8.0 and 8.1 series cannot be run
  # on Java 20: https://github.com/gradle/gradle/issues/23488.
  depends_on "openjdk@17"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env("17")
    (bin/"gradle").write_env_script libexec/"bin/gradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write <<~EOS
      println "gradle works!"
    EOS
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end