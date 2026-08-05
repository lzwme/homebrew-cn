class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://ghfast.top/https://github.com/django/django/archive/refs/tags/6.0.8.tar.gz"
  sha256 "ae848fbfefee9fe2ea453a5f51c98426d54d615144c797b429b59665166ca34e"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4af1685d7c005e80524d21f3059d43d4280020a718c35a6075456b2c0497f4e4"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end