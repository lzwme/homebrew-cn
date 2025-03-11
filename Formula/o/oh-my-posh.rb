class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.3.0.tar.gz"
  sha256 "157f0850e88cd89c202858fc6655b51441a914f4791182613b09e6380623a558"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48dfd234c5e2083da4eb5d8e675257cd541e556ede73991859367508f06fc22b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f795297110a0bfbce53b00364cd52ea72131a102a3d812c8bbc7d8148b882344"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7684fe0f2090b22512ff8e58493974d3cc8cd7796514a9f52655b7257ce7f10e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc956af704ae82d5f1f92e6811affab58eb8a18d887df86b39ff11ffe50c1293"
    sha256 cellar: :any_skip_relocation, ventura:       "217a295e1665577cf8dab9456806978f5d7567327e53a1d5793056c07fdb834d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee84056a33c07ac85dff27afd1c6dc72e82bd635a7e1c9f137c478ed0d4158bc"
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