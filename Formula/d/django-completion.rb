class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://ghfast.top/https://github.com/django/django/archive/refs/tags/5.2.9.tar.gz"
  sha256 "18f94565bdaa1bda2943fd2891665511b89177138869c14aafc81ee297ce1c97"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ddd5de7bdde455e870d8881a7241bdc06eadf1235d783cf3be8fc2bcf0fa90f5"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end