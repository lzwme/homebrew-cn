class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https:get-coursier.io"
  url "https:github.comcoursiercoursierreleasesdownloadv2.1.13coursier.jar"
  sha256 "d6b85f75f093d94963a9077c892e4da91905e17fa5dcb2d4ac8a826a57124819"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3ea86a52193d8841950ba9545c38cf507b637765b0f527d7bbd5e446ef24549"
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