class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv18.3.1.tar.gz"
  sha256 "f250ec0c1955026267533e8c044c1c38a4775c6e70035427745ae161d88ba69e"
  license "MIT"
  head "https:github.comgit-towngit-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "696cc0ab0127524146037b9cb56bbc5ff175283b26223883b1939feb5d8cd7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "696cc0ab0127524146037b9cb56bbc5ff175283b26223883b1939feb5d8cd7c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "696cc0ab0127524146037b9cb56bbc5ff175283b26223883b1939feb5d8cd7c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d279a874ef263544f28bfc03083d3cca69303beaa6bb4267adbaba3b807a3697"
    sha256 cellar: :any_skip_relocation, ventura:       "d279a874ef263544f28bfc03083d3cca69303beaa6bb4267adbaba3b807a3697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "756bf6da2e6afccc1456ce9a758da2dcdc93629812b9f6b3d3a5cef03a1d033a"
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