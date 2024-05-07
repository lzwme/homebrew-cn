class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https:www.djangoproject.com"
  url "https:github.comdjangodjangoarchiverefstags5.0.5.tar.gz"
  sha256 "172bc45228a1d190f022f0caecd3b8a0df0ea6b850af40f932615273b3366e4c"
  license "BSD-3-Clause"
  head "https:github.comdjangodjango.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b3edf71971a1e0812b4ae8c9e5a7e08bff916b4d4259d4b09f1b84415e0d4db"
  end

  def install
    bash_completion.install "extrasdjango_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}django && complete -p django-admin'")
  end
end