class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https:www.djangoproject.com"
  url "https:github.comdjangodjangoarchiverefstags5.2.2.tar.gz"
  sha256 "2f04f422a27f9d00145af42a6788a176317eb9c0e111ed4d666d631b65f88f58"
  license "BSD-3-Clause"
  head "https:github.comdjangodjango.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba271d40a240d21b981b9f88b90a8c2abe49b1d45382a781661d5f6e1b4a477f"
  end

  def install
    bash_completion.install "extrasdjango_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}django && complete -p django-admin'")
  end
end