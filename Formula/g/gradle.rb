class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.8-all.zip"
  sha256 "f8b4f4772d302c8ff580bc40d0f56e715de69b163546944f787c87abf209c961"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5a8957f5ade83c7b7f36fd2f8fd527b727dcbf2630d3c29138fae0ef382f392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5a8957f5ade83c7b7f36fd2f8fd527b727dcbf2630d3c29138fae0ef382f392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5a8957f5ade83c7b7f36fd2f8fd527b727dcbf2630d3c29138fae0ef382f392"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5051137a2865567d9cb07d982eac3b3ac103a8567977bc6f89010861e429ff4"
    sha256 cellar: :any_skip_relocation, ventura:        "a5051137a2865567d9cb07d982eac3b3ac103a8567977bc6f89010861e429ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "a5051137a2865567d9cb07d982eac3b3ac103a8567977bc6f89010861e429ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099b31cc0d0295866a518996aed1a83da1faf37028d40a909d473570546342bb"
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