class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https:github.comkeisgit-fixup"
  url "https:github.comkeisgit-fixuparchiverefstagsv1.5.0.tar.gz"
  sha256 "b110730f37009f8fe26bcbdd83e20a9ccad02367b48cd0cfe50f4ec1a74f0eae"
  license "ISC"
  head "https:github.comkeisgit-fixup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6de34acd070e73748e8412252fad584ffeddacd87b11d1cd1d28fccfeb9e15c1"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
    fish_completion.install "completion.fish" => "git-fixup.fish"
  end

  test do
    (testpath".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath"test").delete
    (testpath"test").write "bar"
    system "git", "add", "test"
    system "git", "fixup"
  end
end