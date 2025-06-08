class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https:github.commystorgit-revise"
  url "https:files.pythonhosted.orgpackages99fe03e0afc973c19af8ebf9c7a4a090a974c0c39578b1d4082d201d126b7f9agit-revise-0.7.0.tar.gz"
  sha256 "af92ca2e7224c5e7ac2e16ed2f302dd36839a33521655c20fe0b7d693a1dc4c4"
  license "MIT"
  head "https:github.commystorgit-revise.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "60d72785f3a41be712e088e432f33aaf774461f8ba07e46bcb95af9cdcbdf358"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath".gitconfig").write <<~EOS
      [user]
        name = J. Random Tester
        email = test@example.com
    EOS

    system "git", "init"
    (testpath"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "a bad message"
    system "git", "revise", "--message", "a good message", "HEAD"
    assert_match "a good message", shell_output("git log --format=%B -n 1 HEAD")
  end
end