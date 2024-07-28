class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.3.0.tar.gz"
  sha256 "fe3d8a70ae48baff89a6ed6c911429255dd0ff33491bb281da55315d9906537e"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ee02ac67892db6235068f9a13f297ac1bb648e0231c4c963d1c7825f158ada3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21ab4983abafb3ed4698a616d1a101540a90d3114ba68c2d9f74033150ba865c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfd9c8649f110ca6e0821fa841855e6748eceb984407e8dc98fecec73f739f12"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a4fa89f53c812822e0066b87a9d0362b6a5342a7f9ad7f7add21391fbb28a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "853effc0ce44ef5a8f9a5906789027c74eb74a6d04d2e7c2813d98e4617dd0fb"
    sha256 cellar: :any_skip_relocation, monterey:       "efc70fc4081146677b66a3f9a63bfa1168c14a6508ffc26324dde44398ca6bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "719732406d6194638f9cf7c9cdeeebc15e2813e572212de519019c15957cb1bd"
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