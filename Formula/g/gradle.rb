class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https:www.gradle.org"
  url "https:services.gradle.orgdistributionsgradle-8.8-all.zip"
  sha256 "f8b4f4772d302c8ff580bc40d0f56e715de69b163546944f787c87abf209c961"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https:gradle.orginstall"
    regex(href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e74dd8ea5b8b7ee1f11a81bc51e987bd4bbeb2ed4aab44ef09e1a751cef751a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e74dd8ea5b8b7ee1f11a81bc51e987bd4bbeb2ed4aab44ef09e1a751cef751a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e74dd8ea5b8b7ee1f11a81bc51e987bd4bbeb2ed4aab44ef09e1a751cef751a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f34aea09fe33ccbdba75de64bedf303221405b2f8ebae11ed842c0487e72698c"
    sha256 cellar: :any_skip_relocation, ventura:        "f34aea09fe33ccbdba75de64bedf303221405b2f8ebae11ed842c0487e72698c"
    sha256 cellar: :any_skip_relocation, monterey:       "f34aea09fe33ccbdba75de64bedf303221405b2f8ebae11ed842c0487e72698c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d7c13cd0e6ccb8a694c2433e3604b32f9de3d7e6030d7850f1e5a6fe11aa724"
  end

  # https:github.comgradlegradleblobmasterplatformsdocumentationdocssrcdocsuserguidereleasescompatibility.adoc
  depends_on "openjdk"

  def install
    rm_f Dir["bin*.bat"]
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
    (bin"gradle").write_env_script libexec"bingradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gradle --version")

    (testpath"settings.gradle").write ""
    (testpath"build.gradle").write <<~EOS
      println "gradle works!"
    EOS
    gradle_output = shell_output("#{bin}gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end