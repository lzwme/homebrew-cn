class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://ghproxy.com/https://github.com/restic/restic/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "88165b5b89b6064df37a9964d660f40ac62db51d6536e459db9aaea6f2b2fc11"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab8097fe55ac20fae8425c25fdb146475e740b0f152c32599b4cc8f480e7fae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab8097fe55ac20fae8425c25fdb146475e740b0f152c32599b4cc8f480e7fae6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab8097fe55ac20fae8425c25fdb146475e740b0f152c32599b4cc8f480e7fae6"
    sha256 cellar: :any_skip_relocation, sonoma:         "761d660cbe6e2537b64828c9e1aaba26a292b63c44a494f41ebe1300c37bbf1e"
    sha256 cellar: :any_skip_relocation, ventura:        "761d660cbe6e2537b64828c9e1aaba26a292b63c44a494f41ebe1300c37bbf1e"
    sha256 cellar: :any_skip_relocation, monterey:       "761d660cbe6e2537b64828c9e1aaba26a292b63c44a494f41ebe1300c37bbf1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bcc76098d86d3fd07b418375ef66f4ad20fc53171cdbdac598fe3ff79d8dd6a"
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