class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.20.1.tar.gz"
  sha256 "5fc4d87e45d8c3ad8497362400abe625ab5dd51f85c6ee3ba5c5ae162206d1b2"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36ad32df3066127b3e5be91f31357d6ff717d30b534490fb3fc28684f326453b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c10d2d026bdec65dbd28b62ad597a6a5c754b509c32ddc34b59542c21c250da3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cf0709f7bbeab5835c9948082a6fbf752684fcd1f494caa2bc81279838de662"
    sha256 cellar: :any_skip_relocation, sonoma:        "e46cdcaf0f34c15ffdb6d0afaaefeeec5aeca0fdcad29f7e90d8fb9b1d79b366"
    sha256 cellar: :any_skip_relocation, ventura:       "5cb043d31c3003ece6897ce7e52c331323a109c1aeaf03124fa94eea2d1574d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c454dd5ffdc67fd29c308259877809fa026ad79be4192bd443128f89dbb395"
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