class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.2.1-all.zip"
  sha256 "7c3ad722e9b0ce8205b91560fd6ce8296ac3eadf065672242fd73c06b8eeb6ee"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb845ba56cfb528ebd2c35f4b7e93ac5a7017a48c5e17df6deceed93fc30f028"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb845ba56cfb528ebd2c35f4b7e93ac5a7017a48c5e17df6deceed93fc30f028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb845ba56cfb528ebd2c35f4b7e93ac5a7017a48c5e17df6deceed93fc30f028"
    sha256 cellar: :any_skip_relocation, ventura:        "0827979f8a88ab5d214ccf22f4627f4d173140ec16f3c09f7a0ad7689bb45f5e"
    sha256 cellar: :any_skip_relocation, monterey:       "0827979f8a88ab5d214ccf22f4627f4d173140ec16f3c09f7a0ad7689bb45f5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0827979f8a88ab5d214ccf22f4627f4d173140ec16f3c09f7a0ad7689bb45f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb845ba56cfb528ebd2c35f4b7e93ac5a7017a48c5e17df6deceed93fc30f028"
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