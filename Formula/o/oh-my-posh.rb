class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.3.3.tar.gz"
  sha256 "3b891ffe89a1fcabb2416f7bbc87857dab4fad970644efebed27cc59a6e271fb"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc202fc82c890876fa04b908c6726686b9fdf5cda7f9c1fca9d6c69d4b64a9b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb1aed9024c87e7ab11929a2a0f6d416ccd9749fe8c85b4de6b659a0b7037e18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa4e791d63c99be8b6b00435a95de8115a07d9549a4cd1b826701111a35653b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4637c819979e57ce56213ec91b07bf45759c23541e51f308f3e6f85b8b2a10f4"
    sha256 cellar: :any_skip_relocation, ventura:        "e6329c0600c75e76a9b0c286cbae5bfb30be7a755525a38a9b1c594033715b8a"
    sha256 cellar: :any_skip_relocation, monterey:       "fbbf128643bc169288c882c4cb6b122337d709cc2bbf211d291b1c7aa703d61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5475977bef07008edf40f588a83547ed277cfb9c60e0e898c3ea8156ab8cd9b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end