class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.10.1.tar.gz"
  sha256 "6406192ea3aefa8b918d4a3fca12d55827ddac96af9677f9b61a957a8a3e7f74"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d56e8429b19cebc380fae04a9b7235af1f939dc1b6bb005e6accbf605a5bf191"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c59ab4980b46de6c86a07b1b8e767380fb9d24ac639966c07343a656bfb68c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c410cc40b3e3a6ce26698e989daa8d302a04545f816ccd336201b0e4d76d394"
    sha256 cellar: :any_skip_relocation, sonoma:         "4164ea52464fb6795f6d31f5cda89b35b10508d40829206278214db6c2dcdaec"
    sha256 cellar: :any_skip_relocation, ventura:        "28557ac605aa9af4180ba58b6d5bf5d4140c9008c6b6ab65efa7c23d7d98fbf9"
    sha256 cellar: :any_skip_relocation, monterey:       "493e2e8f725cb1d4b3985f65abc3d9d88b55e316b5b2d4bb3d90a9bc1848523d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "190b15f35e6da30e788866c132bfa73b44bc2640e294dafe11c5000de48086ad"
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