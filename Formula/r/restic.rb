class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https:restic.net"
  url "https:github.comresticresticarchiverefstagsv0.17.3.tar.gz"
  sha256 "bf0dd73edfae531c24070e2e7833938613f7b179ed165e6b681098edfdf286c8"
  license "BSD-2-Clause"
  head "https:github.comresticrestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0debc30cad0e6e9f7dd0d02c1345865589d691ad796f6ea5e23827638d58862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0debc30cad0e6e9f7dd0d02c1345865589d691ad796f6ea5e23827638d58862"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0debc30cad0e6e9f7dd0d02c1345865589d691ad796f6ea5e23827638d58862"
    sha256 cellar: :any_skip_relocation, sonoma:        "df2cbf0539af846b8302d81bd927230ea283dfc877a83a7a06e35a4c0fc08441"
    sha256 cellar: :any_skip_relocation, ventura:       "df2cbf0539af846b8302d81bd927230ea283dfc877a83a7a06e35a4c0fc08441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04e295026f4b3c1150f5b9c5ee718fd0ddc42835edecaab71441d03f8012bc97"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build.go"

    mkdir "completions"
    system ".restic", "generate", "--bash-completion", "completionsrestic"
    system ".restic", "generate", "--zsh-completion", "completions_restic"
    system ".restic", "generate", "--fish-completion", "completionsrestic.fish"

    mkdir "man"
    system ".restic", "generate", "--man", "man"

    bin.install "restic"
    bash_completion.install "completionsrestic"
    zsh_completion.install "completions_restic"
    fish_completion.install "completionsrestic.fish"
    man1.install Dir["man*.1"]
  end

  test do
    mkdir testpath"restic_repo"
    ENV["RESTIC_REPOSITORY"] = testpath"restic_repo"
    ENV["RESTIC_PASSWORD"] = "foo"

    (testpath"testfile").write("This is a testfile")

    system bin"restic", "init"
    system bin"restic", "backup", "testfile"

    system bin"restic", "restore", "latest", "-t", "#{testpath}restore"
    assert compare_file "testfile", "#{testpath}restoretestfile"
  end
end