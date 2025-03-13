class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.4.1.tar.gz"
  sha256 "5178fa9106ad8dfdc7502cc0483b28bb6a0fe60816c3219234a8a748237d9859"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b43ebe9137ca3972a9a6ff7535217a6fd0c921cadaec849b1e74c552eae0ac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "649f440eb2a9f453ffab8423775c484fdeabbc0fa96491766dd181a357f27ebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d70b7236996bc9c771f49963f524bf6ba9e242a536164ab969b306d497f0660f"
    sha256 cellar: :any_skip_relocation, sonoma:        "beda174ae3c2da1272b073a72076f3e17fefcf539d32f6c5df83aa199d121c24"
    sha256 cellar: :any_skip_relocation, ventura:       "f3b720e825f157368f0461903f9168cd35cda64ba92e50a5c61365f01d1d6848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63adbdf6f7c7c1e7e98f0c938c9a5edd009252f8b1a8614ae89a7bba229fe8ae"
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