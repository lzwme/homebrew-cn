class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.16.2.tar.gz"
  sha256 "f26c6038a1d510ea443fbf712a364a54f1dcf1675b378544ff31b2e26f93b408"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8583cc41bee5d020be7c72bccb5ce2916deb036aba736933b6b387a0ed91fa86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d47c69661adaac4b962de15a20ff4cbcdb5548ef201fed733601131c86ae351e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac3aeda7bd4b709989c822a2227893db86b73b7f3d37267fc4e32da7fe598e0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "79e363750a58eaa90e38a3712cdbb579b4aad521bbae212cbad56e34a7183657"
    sha256 cellar: :any_skip_relocation, ventura:        "141304c3f1c95b89c8ea71d2fd7c50ef25d0d7c954e81665ed666a8df599f89a"
    sha256 cellar: :any_skip_relocation, monterey:       "c0682d2d1fbd91610c6fc08d6d642a62cca42852f7e81a58fd70b31b24e3a15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d44ad670b9d6fefa022d1fe115a1ad30169125f40f0680e887cf36adab693a6"
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