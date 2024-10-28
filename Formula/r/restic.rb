class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https:restic.net"
  url "https:github.comresticresticarchiverefstagsv0.17.2.tar.gz"
  sha256 "ac52843c40bc9b520bb8dbbbaeda6afec7a35c59753b8cbf11348dd734896ed1"
  license "BSD-2-Clause"
  head "https:github.comresticrestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3009e4a833d5238bb51a1409d9478ae2833f7328330ca189b0a989e84a5ce34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3009e4a833d5238bb51a1409d9478ae2833f7328330ca189b0a989e84a5ce34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3009e4a833d5238bb51a1409d9478ae2833f7328330ca189b0a989e84a5ce34"
    sha256 cellar: :any_skip_relocation, sonoma:        "01df0b8c186c74010c224c651fdbed0cf37e812ba583127a1267df41c5ec7673"
    sha256 cellar: :any_skip_relocation, ventura:       "01df0b8c186c74010c224c651fdbed0cf37e812ba583127a1267df41c5ec7673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3d8528225b381f3d74decf95d057cd65834360536dd4b2aa5732977ac9cfa6"
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