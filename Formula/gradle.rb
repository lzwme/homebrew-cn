class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.2-all.zip"
  sha256 "5022b0b25fe182b0e50867e77f484501dba44feeea88f5c1f13b6b4660463640"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e147cd2d5fa3704c8e24381be4d605929e3377e07ecf0407bc2e8b43f414e40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e147cd2d5fa3704c8e24381be4d605929e3377e07ecf0407bc2e8b43f414e40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e147cd2d5fa3704c8e24381be4d605929e3377e07ecf0407bc2e8b43f414e40"
    sha256 cellar: :any_skip_relocation, ventura:        "f774055fd89619e06353a4e3b955812ce0dfdddac6a159d6402daea7ac532796"
    sha256 cellar: :any_skip_relocation, monterey:       "f774055fd89619e06353a4e3b955812ce0dfdddac6a159d6402daea7ac532796"
    sha256 cellar: :any_skip_relocation, big_sur:        "f774055fd89619e06353a4e3b955812ce0dfdddac6a159d6402daea7ac532796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e147cd2d5fa3704c8e24381be4d605929e3377e07ecf0407bc2e8b43f414e40"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
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