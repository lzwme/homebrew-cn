class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https:www.djangoproject.com"
  url "https:github.comdjangodjangoarchiverefstags5.1.tar.gz"
  sha256 "64509508cfcd461af9da5b139df8839a1ce8fa0c86683678bfc5ab01a392efa8"
  license "BSD-3-Clause"
  head "https:github.comdjangodjango.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "083472d12b7020db8f2efae6eb17a6767db8e5b96f0e364c850c13cb46d7e7de"
  end

  def install
    bash_completion.install "extrasdjango_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}django && complete -p django-admin'")
  end
end