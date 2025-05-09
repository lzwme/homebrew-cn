class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv20.1.0.tar.gz"
  sha256 "a2e3ffcc2b69d1279ad07da08fdf780103bae1bd7cc3cfa38f97898abf8515a0"
  license "MIT"
  head "https:github.comgit-towngit-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d6a0bcbc8dca29ce3a22847c9d910db936c58ca1cbdc3bdd4bbf97fb873f151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d6a0bcbc8dca29ce3a22847c9d910db936c58ca1cbdc3bdd4bbf97fb873f151"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d6a0bcbc8dca29ce3a22847c9d910db936c58ca1cbdc3bdd4bbf97fb873f151"
    sha256 cellar: :any_skip_relocation, sonoma:        "56ad14c0a9b0b4c0a9f0578fa87ce4747cf143b0b03e87a5137f0f284ba11203"
    sha256 cellar: :any_skip_relocation, ventura:       "56ad14c0a9b0b4c0a9f0578fa87ce4747cf143b0b03e87a5137f0f284ba11203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a38c69a1d44f517fec7377a3d500fe391ae90d663a97b47612631b676873d328"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end