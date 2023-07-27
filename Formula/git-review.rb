class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  revision 1
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4adaadaba7e9bdb9d945b46d9d7d0d9bf103d7d942ea2208bfc4e7ff58d12c23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc6e621d35643e3ed021de2ed4370a50689c0b03b188c9bb4ac4a057be2c0bd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d26024685025c204008bba1022dd2dcf6dd478a56f08701b0ba1a6c2639fcd19"
    sha256 cellar: :any_skip_relocation, ventura:        "ce5a261a9b344170b4797cec3e7bb220dd0a324df8527f2ca9dcda6cbb73f36e"
    sha256 cellar: :any_skip_relocation, monterey:       "91dd0934b7ea3a6b8c643833683da1048ca614c89285b3ad18885556ce68c589"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff3f88fc1a40f1a0ae7d63e2c521a31db0fbcb1b40275060d3bfacedd8e5dd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "698bb2a79c8f17d3db351b697520175101a6b06267cc3fa5dc83f4468ffa2c13"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
    man1.install Utils::Gzip.compress("git-review.1")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end