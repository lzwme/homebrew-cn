class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/4d/9e/538f1ed26a78b216fdd3aeae69385db83d2d4c21ca9894423eb709a86fa4/git_delete_merged_branches-7.6.1.tar.gz"
  sha256 "25dbf28cdf831cf1cf4639b55fa5b9166a1aa67f261da35cdbb2931dff53bf7b"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cfc06a6fecaa00f349cf31b83231877d93cfa4ea549b392c5dd76ef877e5dd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "830cce405a9df04de0821a02689529e0a34f861cd27ad8efecae00652543ce1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b26448707ef0b0089a5d8730bae3bb7fffa531c653d49656098e22a63fd5160"
    sha256 cellar: :any,                 arm64_linux:       "0a1d152a9ae57ed3917ce1fd017299f6e334fd36aa1d3e887edfc5667a09d506"
    sha256 cellar: :any,                 x86_64_linux:      "11ccbe0f7e7ea10f3e7fb6de6d0845105b124316a553aa440713255dfe862c55"
  end

  depends_on "python@3.15"

  conflicts_with "git-extras", because: "both install `git-delete-merged-branches` binaries"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    origin = testpath/"origin"
    origin.mkdir
    clone = testpath/"clone"

    cd origin do
      system "git", "init", "--initial-branch", "master"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@example.com"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"
    end

    system "git", "clone", origin, clone

    cd clone do
      system "git", "config", "remote.origin.dmb-enabled", "true"
      system "git", "config", "branch.master.dmb-required", "true"
      system "git", "config", "delete-merged-branches.configured", "5.0.0+"
      system "git", "checkout", "-b", "new-branch"
      system "git", "checkout", "-"
      system "git", "delete-merged-branches", "--yes"
      branches = shell_output("git branch").split("\n")
      assert_equal 1, branches.length
    end
  end
end