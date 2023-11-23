class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https://get-coursier.io/"
  url "https://ghproxy.com/https://github.com/coursier/coursier/releases/download/v2.1.8/coursier.jar"
  sha256 "2b78bfdd3ef13fd1f42f158de0f029d7cbb1f4f652d51773445cf2b6f7918a87"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b57664f1d37cb50221ee47545797e49902f11251e8c234ab51dcbef08296f904"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "coursier.jar"
    chmod 0755, libexec/"bin/coursier.jar"
    (bin/"coursier").write_env_script libexec/"bin/coursier.jar", Language::Java.overridable_java_home_env

    generate_completions_from_executable("bash", bin/"coursier", "completions", shells: [:bash, :zsh])
  end

  test do
    system bin/"coursier", "list"
    assert_match "scalafix", shell_output("#{bin}/coursier search scalafix")
  end
end