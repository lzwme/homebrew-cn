class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https:opendev.orgopendevgit-review"
  url "https:files.pythonhosted.orgpackagesda92ddc922d34061791a4d0fd483ee4ffc5e026e93783b70fe5a29a129d0cf63git_review-2.5.0.tar.gz"
  sha256 "1bcffaef02848a5a3b066e8268c7d700a77cbd8b2e56b128d30f60cd431cf0a8"
  license "Apache-2.0"
  head "https:opendev.orgopendevgit-review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da26337e70cdd57dd7c0de2d2fdf9f3d2ab8cd16101418e73826da5cb3167271"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  conflicts_with "gerrit-tools", because: "both install `git-review` binaries"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https:github.comHomebrewbrew.sh"
    (testpath".githookscommit-msg").write "# empty - make git-review happy"
    (testpath"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system bin"git-review", "--dry-run"
  end
end