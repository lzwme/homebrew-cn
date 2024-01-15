class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https:restic.net"
  url "https:github.comresticresticarchiverefstagsv0.16.3.tar.gz"
  sha256 "a94d6c1feb0034fcff3e8b4f2d65c0678f906fc21a1cf2d435341f69e7e7af52"
  license "BSD-2-Clause"
  head "https:github.comresticrestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d3f43d18da36be74a021ffa96f7587cbd61b070c694228538b24dc120908b5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3f43d18da36be74a021ffa96f7587cbd61b070c694228538b24dc120908b5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d3f43d18da36be74a021ffa96f7587cbd61b070c694228538b24dc120908b5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "23bc4c4f33e7051059c5e452920254bf26b766086e6d18f94672fd8e0359027f"
    sha256 cellar: :any_skip_relocation, ventura:        "23bc4c4f33e7051059c5e452920254bf26b766086e6d18f94672fd8e0359027f"
    sha256 cellar: :any_skip_relocation, monterey:       "23bc4c4f33e7051059c5e452920254bf26b766086e6d18f94672fd8e0359027f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27470621ba9b169279589919990623b56619f479b7d419b0e3759a5e4ad04412"
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