class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https:github.comgradlegradle-profiler"
  url "https:search.maven.orgremotecontent?filepath=orggradleprofilergradle-profiler0.20.0gradle-profiler-0.20.0.zip"
  sha256 "5eb01652a348dd929f8ca03231bd7906521b75463003e085dcb49a59612bbaa2"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orggradleprofilergradle-profilermaven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*<version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a995687e972bf699a77deffa4bed8fde8e1bdfcafdae76abcf10a734d12a9d78"
  end

  # gradle currently does not support Java 17 (ARM)
  # gradle@6 is still default gradle-version, but does not support Java 16
  # Switch to `openjdk` once above situations are no longer true
  depends_on "openjdk@11"

  def install
    rm(Dir["bin*.bat"])
    libexec.install %w[bin lib]
    env = Language::Java.overridable_java_home_env("11")
    (bin"gradle-profiler").write_env_script libexec"bingradle-profiler", env
  end

  test do
    (testpath"settings.gradle").write ""
    (testpath"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}gradle-profiler --gradle-version 7.0 --profile chrome-trace")
    assert_includes output, "* Results written to"
  end
end