class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://ghproxy.com/https://github.com/django/django/archive/4.2.1.tar.gz"
  sha256 "48eaaf64c36642aa570dce64f08b32f317e9819f6ec4b6ebfa2ed4e7cd3e5aae"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87ccf9fdd3b3edf6a23a2778b6185aa1818e2748c874926254f09d938ea2266e"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end