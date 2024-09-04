class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https:www.djangoproject.com"
  url "https:github.comdjangodjangoarchiverefstags5.1.1.tar.gz"
  sha256 "5405fccebefbde3b257af3c638a5aa64944a2bac55f058128a0512ffb2b765ae"
  license "BSD-3-Clause"
  head "https:github.comdjangodjango.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5dbefd37d1f8514df5b82a1377f730b958c30cd56d03045cee781c2ea387d4e9"
  end

  def install
    bash_completion.install "extrasdjango_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}django && complete -p django-admin'")
  end
end