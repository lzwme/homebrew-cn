class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https:github.comgradlegradle-profiler"
  url "https:search.maven.orgremotecontent?filepath=orggradleprofilergradle-profiler0.22.0gradle-profiler-0.22.0.zip"
  sha256 "a269f05861d2682c3b98d050330764200bc322024762295713fab167d133283c"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orggradleprofilergradle-profilermaven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*<version>}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4fdec547a78284921b7ccb437e045ec11fa0d0b16cf4959fbd2ddd8081209498"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin*.bat"])
    libexec.install %w[bin lib]
    env = Language::Java.overridable_java_home_env
    (bin"gradle-profiler").write_env_script libexec"bingradle-profiler", env
  end

  test do
    (testpath"settings.gradle").write ""
    (testpath"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}gradle-profiler --gradle-version 8.14 --profile chrome-trace")
    assert_includes output, "* Writing results to"
  end
end