class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https:github.comgit-buggit-bug"
  url "https:github.comgit-buggit-bugarchiverefstagsv0.10.0.tar.gz"
  sha256 "84391695b94bd628236cf263e86996c249e390d1a97acc41af21bc7d44346aca"
  license "GPL-3.0-or-later"
  head "https:github.comgit-buggit-bug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80487cab259387a38f0f4ed236d958a9156f98f1e6f061575bfc698ff6e39962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4973b24889ec240b81e1984fdbfbe650060669db1e2936985b588624af0ebd9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bda350b12c69f7f6424c2f0f334dce0864d920d709568aa884348ae04816dc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "43dd81ce740c787bc7f113a2929ef7cf160965345fbb9021fd7b3911d1b1b382"
    sha256 cellar: :any_skip_relocation, ventura:       "acdf976be32c223fe55ccd5a2cbee3debf4d832bea8b3338b0e17a632f54c7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3e3b25a45703e0d8891466c8eeb43c3920d17fc17b2ef156c6321dc7b7476c"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ldflags = %W[
      -s -w
      -X github.comgit-buggit-bugcommands.GitCommit="v#{tap.user}"
      -X github.comgit-buggit-bugcommands.GitLastTag="v#{version}"
      -X github.comgit-buggit-bugcommands.GitExactTag="v#{version}"
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:)

    man1.install Dir["docman*.1"]
    doc.install Dir["docmd*.md"]

    bash_completion.install "misccompletionbashgit-bug"
    zsh_completion.install "misccompletionzshgit-bug" => "_git-bug"
    fish_completion.install "misccompletionfishgit-bug" => "git-bug.fish"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}git-bug version")
    # Version through git
    assert_match version.to_s, shell_output("git bug version")

    mkdir testpath"git-repo" do
      system "git", "init", "--initial-branch=main"
      system "git", "config", "user.name", "homebrew"
      system "git", "config", "user.email", "a@a.com"
      system "yes 'a b http:wwwwww' | git bug user new"
      system "git", "bug", "bug", "new", "-t", "Issue 1", "-m", "Issue body"
      system "git", "bug", "bug", "new", "-t", "Issue 2", "-m", "Issue body"
      system "git", "bug", "bug", "new", "-t", "Issue 3", "-m", "Issue body"

      assert_match "Issue 2", shell_output("git bug bug 'Issue 2'")
    end
  end
end