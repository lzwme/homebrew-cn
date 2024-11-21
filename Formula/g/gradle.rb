class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https:www.gradle.org"
  url "https:services.gradle.orgdistributionsgradle-8.11.1-all.zip"
  sha256 "89d4e70e4e84e2d2dfbb63e4daa53e21b25017cc70c37e4eea31ee51fb15098a"
  license "Apache-2.0"

  livecheck do
    url "https:gradle.orginstall"
    regex(href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63d32d1551162ccf0fefb53610566bd9ef75253175ea69b5ffab705b837e7adb"
  end

  # https:github.comgradlegradleblobmasterplatformsdocumentationdocssrcdocsuserguidereleasescompatibility.adoc
  depends_on "openjdk"

  def install
    rm(Dir["bin*.bat"])
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
    (bin"gradle").write_env_script libexec"bingradle", env

    # Ensure we have uniform bottles.
    inreplace libexec"srcjvm-servicesorggradlejvmtoolchaininternalLinuxInstallationSupplier.java",
              "usrlocal", HOMEBREW_PREFIX
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