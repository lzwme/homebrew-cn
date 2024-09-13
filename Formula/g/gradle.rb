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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c9932cfacbdb888c1666c13327d7870115a5b2e621819e365491aa5468f56a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9932cfacbdb888c1666c13327d7870115a5b2e621819e365491aa5468f56a85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9932cfacbdb888c1666c13327d7870115a5b2e621819e365491aa5468f56a85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9932cfacbdb888c1666c13327d7870115a5b2e621819e365491aa5468f56a85"
    sha256 cellar: :any_skip_relocation, sonoma:         "a305b21269985234e2e28eb0537db40b98b6b0150c98da8ce8c2c10838b6064b"
    sha256 cellar: :any_skip_relocation, ventura:        "a305b21269985234e2e28eb0537db40b98b6b0150c98da8ce8c2c10838b6064b"
    sha256 cellar: :any_skip_relocation, monterey:       "a305b21269985234e2e28eb0537db40b98b6b0150c98da8ce8c2c10838b6064b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9932cfacbdb888c1666c13327d7870115a5b2e621819e365491aa5468f56a85"
  end

  # https:github.comgradlegradleblobmasterplatformsdocumentationdocssrcdocsuserguidereleasescompatibility.adoc
  depends_on "openjdk"

  def install
    rm(Dir["bin*.bat"])
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