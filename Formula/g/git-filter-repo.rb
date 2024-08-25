class GitFilterRepo < Formula
  include Language::Python::Shebang

  desc "Quickly rewrite git repository history"
  homepage "https:github.comnewrengit-filter-repo"
  url "https:github.comnewrengit-filter-reporeleasesdownloadv2.45.0git-filter-repo-2.45.0.tar.xz"
  sha256 "430a2c4a5d6f010ebeafac6e724e3d8d44c83517f61ea2b2d0d07ed8a6fc555a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8f7071f5bf8c0c81c00c7c3f543e8e1c80e2f4dc7351dc8b190d22eacaa15abc"
  end

  depends_on "python@3.12"
  uses_from_macos "git", since: :catalina # git 2.22.0+ is required

  def install
    rewrite_shebang detected_python_shebang, "git-filter-repo"
    bin.install "git-filter-repo"
    man1.install "Documentationman1git-filter-repo.1"
  end

  test do
    system bin"git-filter-repo", "--version"

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"

    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "foo"
    # Use --force to accept non-fresh clone run:
    # Aborting: Refusing to overwrite repo history since this does not look like a fresh clone.
    # (expected freshly packed repo)
    system bin"git-filter-repo", "--path-rename=foo:bar", "--force"

    assert_predicate testpath"bar", :exist?
  end
end