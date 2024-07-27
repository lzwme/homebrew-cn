class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https:restic.net"
  url "https:github.comresticresticarchiverefstagsv0.17.0.tar.gz"
  sha256 "031cf34eeafe09064a6b63bcf752093d742b89166e93924aa4dde13160f91301"
  license "BSD-2-Clause"
  head "https:github.comresticrestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94b215d3aa7f2fd78c34143a6468adf1ad94714404fadef23870f98750de4170"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94b215d3aa7f2fd78c34143a6468adf1ad94714404fadef23870f98750de4170"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94b215d3aa7f2fd78c34143a6468adf1ad94714404fadef23870f98750de4170"
    sha256 cellar: :any_skip_relocation, sonoma:         "51c7f4cbe46df14860bac6a57f1133d887212aeea8f0aae53aa218cff18fe811"
    sha256 cellar: :any_skip_relocation, ventura:        "51c7f4cbe46df14860bac6a57f1133d887212aeea8f0aae53aa218cff18fe811"
    sha256 cellar: :any_skip_relocation, monterey:       "51c7f4cbe46df14860bac6a57f1133d887212aeea8f0aae53aa218cff18fe811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc16a5e2d06f28fb1910644a41fbdb1de76cd21983d1278ac40ad80288c0e29"
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

    system "#{bin}restic", "init"
    system "#{bin}restic", "backup", "testfile"

    system "#{bin}restic", "restore", "latest", "-t", "#{testpath}restore"
    assert compare_file "testfile", "#{testpath}restoretestfile"
  end
end