class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https:github.comgit-big-picturegit-big-picture"
  url "https:github.comgit-big-picturegit-big-picturearchiverefstagsv1.3.0.tar.gz"
  sha256 "cccbd3e35dfe6d0ce86d06079e80cf9219cb25f887c7a782e2808e740dc23c3a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f349a70b4e1696b630b31953b156b2aa60905b3e572b1f203ca72bc507caac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f349a70b4e1696b630b31953b156b2aa60905b3e572b1f203ca72bc507caac8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f349a70b4e1696b630b31953b156b2aa60905b3e572b1f203ca72bc507caac8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f349a70b4e1696b630b31953b156b2aa60905b3e572b1f203ca72bc507caac8"
    sha256 cellar: :any_skip_relocation, ventura:        "6f349a70b4e1696b630b31953b156b2aa60905b3e572b1f203ca72bc507caac8"
    sha256 cellar: :any_skip_relocation, monterey:       "6f349a70b4e1696b630b31953b156b2aa60905b3e572b1f203ca72bc507caac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1843e072083aad22f5f576c2077ea634d391d8c525dd7304362b4b0d4c5d3c"
  end

  depends_on "graphviz"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Empty commit"
    system "git", "big-picture", "-f", "svg", "-o", "output.svg"
    assert_path_exists testpath"output.svg"
  end
end