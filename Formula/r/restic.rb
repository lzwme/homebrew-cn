class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://ghproxy.com/https://github.com/restic/restic/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "31339090e3e8a044d014b9341c025cf59bf7bc133ae267bc5acdea5ac07837a9"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b1ab400a5e094398ba658c44af4dcb5368ff5211d9faa97dfa75a87ab58b9de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b1ab400a5e094398ba658c44af4dcb5368ff5211d9faa97dfa75a87ab58b9de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b1ab400a5e094398ba658c44af4dcb5368ff5211d9faa97dfa75a87ab58b9de"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a7b110e6e5bf9b57e42ed500f50256178b58a25934bea17b01c0442bdaa6864"
    sha256 cellar: :any_skip_relocation, ventura:        "5a7b110e6e5bf9b57e42ed500f50256178b58a25934bea17b01c0442bdaa6864"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7b110e6e5bf9b57e42ed500f50256178b58a25934bea17b01c0442bdaa6864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82a66d01dde99ff56beab3bd03769f0fdc7b1e82624c933c5bf2eb15e0a2e2c"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build.go"

    mkdir "completions"
    system "./restic", "generate", "--bash-completion", "completions/restic"
    system "./restic", "generate", "--zsh-completion", "completions/_restic"
    system "./restic", "generate", "--fish-completion", "completions/restic.fish"

    mkdir "man"
    system "./restic", "generate", "--man", "man"

    bin.install "restic"
    bash_completion.install "completions/restic"
    zsh_completion.install "completions/_restic"
    fish_completion.install "completions/restic.fish"
    man1.install Dir["man/*.1"]
  end

  test do
    mkdir testpath/"restic_repo"
    ENV["RESTIC_REPOSITORY"] = testpath/"restic_repo"
    ENV["RESTIC_PASSWORD"] = "foo"

    (testpath/"testfile").write("This is a testfile")

    system "#{bin}/restic", "init"
    system "#{bin}/restic", "backup", "testfile"

    system "#{bin}/restic", "restore", "latest", "-t", "#{testpath}/restore"
    assert compare_file "testfile", "#{testpath}/restore/testfile"
  end
end