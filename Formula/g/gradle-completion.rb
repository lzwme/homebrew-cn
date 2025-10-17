class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://ghfast.top/https://github.com/gradle/gradle-completion/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "ae8f8caa79950385ada597bb6d9ba08a3668e04f771bd997b5e6c41c6aec22ea"
  license "MIT"
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4faa47a38513af76b6475cdb52c7410cde692983e3e9fc013aedb3ce7b43101"
  end

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end