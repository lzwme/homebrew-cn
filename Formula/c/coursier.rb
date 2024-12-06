class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https:get-coursier.io"
  url "https:github.comcoursiercoursierreleasesdownloadv2.1.20coursier.jar"
  sha256 "b025a180b5918e27fbc286f4a9ef7622ecd2bd0f7cf482c3522a71db7162e0f8"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "954ff17c02ad5ebaddc59ba2b7d70b845dfa746929f7b8de86158c075e53401d"
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