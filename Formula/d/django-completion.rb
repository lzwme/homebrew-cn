class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://ghproxy.com/https://github.com/django/django/archive/refs/tags/5.0.tar.gz"
  sha256 "7239bc0814af1281101e834ee436a5996320839b382eb228b79f1a9b077a1de0"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36b3e78271be3a9f89572b263384b389f58504ce425731fddbda2b9800b21863"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end