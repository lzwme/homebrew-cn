class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.8.0.tar.gz"
  sha256 "75bdc19cb0b3943815d35c464f5e96ed9cff3940ee06609d7a8b373645914fbc"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fad594ff81067f65fb4bfa99bd9af6796319c06fc42144e8c29a6d62057f316d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dfd3f7bde06893e7d0c270f55ce3b8922ade1226ea866874615973764bdbd10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c4a91f6388fb75dc0f162dc94e7b7af3c812a72f2dd609ab03248e8b684cfda"
    sha256 cellar: :any_skip_relocation, sonoma:        "75fdcec9016db4f013fa8a09355272179c049bf05af650b293580f58ccca0345"
    sha256 cellar: :any_skip_relocation, ventura:       "11c050cf5cc808cdd550f13706aa53c5a6d4a64e0a2f2ca9f5294ae4c2d51944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5c59b993b848316c60abdc410a553174291504414860fa7721bda88e956883"
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
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end