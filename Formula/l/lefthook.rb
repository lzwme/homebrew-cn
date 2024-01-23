class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.0.tar.gz"
  sha256 "cffc24a18a09d88a126db3bb58723116487cd0abb72b7f51cfcacf462a01f099"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9d5a8230000d356c80f33ddc8192e765aa835d8dec14068e71dd7f0aea1364f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a31b4d12aaff4d7fb343f30cd9e0949358f321a9dc806d2da4a3cd6ed7bac28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7af36cf1b8cc3a1ab8d5510a12ab1420684ffbc410327a55cc557fb505c9a78"
    sha256 cellar: :any_skip_relocation, sonoma:         "611b3c66214948835571fe8424e6cb52c046a78e2024b11bca1a655082c33045"
    sha256 cellar: :any_skip_relocation, ventura:        "8ceba91a1f094762218d7d25b04c51ca2d3f9b9fd27601076dfd3b1644d49ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "172ec35a002a6e16137e610a7a1c190ebdc07ecb570e541e8f53dd91b777834e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a57fbb61a05fcdd408363b20c58d78fcde806aefe9b44350e4180a69b694345"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end