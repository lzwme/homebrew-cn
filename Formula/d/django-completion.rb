class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://ghfast.top/https://github.com/django/django/archive/refs/tags/5.2.5.tar.gz"
  sha256 "9c0b9cb2e5c99e699cb3a05238ba8efba1fd31baf4bbbbb9e6dd662bb5b3286b"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bace90132eaeae5780ac9248ae27a428e4bb0b4b81ea2f7e7af7f42737f781d2"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end