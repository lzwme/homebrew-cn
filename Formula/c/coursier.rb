class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https:get-coursier.io"
  url "https:github.comcoursiercoursierreleasesdownloadv2.1.18coursier.jar"
  sha256 "04926cfdcdcfa36c8c5ccfb3c462eecf9984ed4e4cecbaf42834373f34132d7f"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2caca6963408ae577899007a0983eeb7611c7bbe996486070bd10bfe1f38d9e"
  end

  depends_on "openjdk"

  def install
    (libexec"bin").install "coursier.jar"
    chmod 0755, libexec"bincoursier.jar"
    (bin"coursier").write_env_script libexec"bincoursier.jar", Language::Java.overridable_java_home_env

    generate_completions_from_executable("bash", bin"coursier", "completions", shells: [:bash, :zsh])
  end

  test do
    system bin"coursier", "list"
    assert_match "scalafix", shell_output("#{bin}coursier search scalafix")
  end
end