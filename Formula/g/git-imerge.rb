class GitImerge < Formula
  include Language::Python::Virtualenv

  desc "Incremental merge for git"
  homepage "https:github.commhaggergit-imerge"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.commhaggergit-imerge.git", branch: "master"

  stable do
    url "https:files.pythonhosted.orgpackagesbef6ea97fb920d7c3469e4817cfbf9202db98b4a4cdf71d8740e274af57d728cgit-imerge-1.2.0.tar.gz"
    sha256 "df5818f40164b916eb089a004a47e5b8febae2b4471a827e3aaa4ebec3831a3f"

    # PR ref, https:github.commhaggergit-imergepull176
    # remove in next release
    patch :DATA
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "f889e12d851617cfc36b7af9f0994b42ca348d9bbd3b0ca6848b79d1bc51f55a"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
    bash_completion.install "completionsgit-imerge"
  end

  test do
    system "git", "config", "--global", "init.defaultBranch", "master"
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"

    system "git", "checkout", "-b", "test"
    (testpath"test").append_lines "bar"
    system "git", "commit", "-m", "Second commit", "test"
    assert_equal "Already up-to-date.", shell_output("#{bin}git-imerge merge master").strip

    system "git", "checkout", "master"
    (testpath"bar").write "bar"
    system "git", "add", "bar"
    system "git", "commit", "-m", "commit bar"
    system "git", "checkout", "test"

    expected_output = <<~EOS
      Attempting automerge of 1-1...success.
      Autofilling 1-1...success.
      Recording autofilled block MergeState('master', tip1='test', tip2='master', goal='merge')[0:2,0:2].
      Merge is complete!
    EOS
    assert_match expected_output, shell_output("#{bin}git-imerge merge master 2>&1")
  end
end

__END__
$ git diff
diff --git asetup.py bsetup.py
index 3ee0551..27a03a6 100644
--- asetup.py
+++ bsetup.py
@@ -14,6 +14,9 @@ try:
 except OSError as e:
     if e.errno != errno.ENOENT:
         raise
+except subprocess.CalledProcessError:
+    # `bash-completion` is probably not installed. Just skip it.
+    pass
 else:
     completionsdir = completionsdir.strip().decode('utf-8')
     if completionsdir: