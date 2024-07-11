class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.23.2.tar.gz"
  sha256 "e5750179cd5314c6005d5a865c4f320626acf698be5cffcbace4a4e43bf9488b"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09ee0a6048d44d949616ce4131f23194198c69fb28638cdb56b4c9394058dc77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9785f9186d76b9dd290b96f5d9a58cc1003cdf57ee5cbd75f9aa6df7fcc227f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c136de7e6835f36f731016a03978f5acd3e4be0c992cb0eeceecfb425a25e95"
    sha256 cellar: :any_skip_relocation, sonoma:         "561ac70acbdf5e765faf75eb730baa2421799086087bbd5d8adead4c2a5467c4"
    sha256 cellar: :any_skip_relocation, ventura:        "ba74ef5de91031643f2fcff6f58a784a0deaeee98e07df08dea65aff9c30a6ee"
    sha256 cellar: :any_skip_relocation, monterey:       "1a108814a5daa7c391ccdc9393c3e4b79ccf0eee89e8b0b77f788c72c8e91f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e36d107e8a144c042fcf90a7a1a12da1c8d7b4d2389c7ef93086a8b8ddd12eb"
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