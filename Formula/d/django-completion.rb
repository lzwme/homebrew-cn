class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https:www.djangoproject.com"
  url "https:github.comdjangodjangoarchiverefstags5.1.4.tar.gz"
  sha256 "adbb3c6702033d417401ce1925f7307b70ee2d8bfca636c82c66a38c55b97dda"
  license "BSD-3-Clause"
  head "https:github.comdjangodjango.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c41d82537aea67713a2d905594ba0e1d245310530209faaf7905f8f8db9f178e"
  end

  def install
    bash_completion.install "extrasdjango_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}django && complete -p django-admin'")
  end
end