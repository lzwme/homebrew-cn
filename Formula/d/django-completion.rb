class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://ghfast.top/https://github.com/django/django/archive/refs/tags/6.0.tar.gz"
  sha256 "a6d0e6620ec7025ee2376f107a572ee9c1d731230ce4634b0a1668a3786dba8a"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7643e7cf51fb6c6b39253f3df90aa790eba6643912930df1895e77ce91da4ba8"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end