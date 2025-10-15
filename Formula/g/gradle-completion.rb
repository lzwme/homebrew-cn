class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://ghfast.top/https://github.com/gradle/gradle-completion/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "873ee5d3fcd416d6400bbeff0729343e3a85d60914a7dc3d664baf9ff726caa5"
  license "MIT"
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95cba04dee9d47fb83e3d24a255652e42693ff14eba0ba5ba77f4f123332997c"
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