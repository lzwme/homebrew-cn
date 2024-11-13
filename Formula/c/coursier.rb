class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https:get-coursier.io"
  url "https:github.comcoursiercoursierreleasesdownloadv2.1.17coursier.jar"
  sha256 "c761694f750196182e492345e45a285d0d8cdf0877a81b8d2c7bad3482038e2b"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7dd01d028c137d6a43b0dbbeb409a952809337e791ec83b9fba4ff13ae958b04"
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