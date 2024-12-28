class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https:get-coursier.io"
  url "https:github.comcoursiercoursierreleasesdownloadv2.1.23coursier.jar"
  sha256 "520c0c3dea3e5d075542e874d33e4cfac5a9bf3f461a3d4a9e6fba4032f7f007"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "461e9f31fb8cb6970a4e7c0ef4a053555ba619eec829992d8f62bdb290b198a8"
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