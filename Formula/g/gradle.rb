class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https:www.gradle.org"
  url "https:services.gradle.orgdistributionsgradle-8.10.1-all.zip"
  sha256 "fdfca5dbc2834f0ece5020465737538e5ba679deeff5ab6c09621d67f8bb1a15"
  license "Apache-2.0"

  livecheck do
    url "https:gradle.orginstall"
    regex(href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dd3f1b22c4e7913630335240a1209cbf4679763a08587d1b97b76b8d0286996f"
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