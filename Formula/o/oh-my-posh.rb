class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.11.0.tar.gz"
  sha256 "e645fb1064ae6065bd0be3ec7673d1db7c64bf5c0c5ee65d24f38d90772013f0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "639e7eee1e24b559c66e5c6aaaf7e8c09a186174f6ea30b5c71cce4ae622e982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b9f8274e464837b507f74e4ab30f22e9aaf10c9ac2b9d834d7f8b58d991a45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "159c4b8b4b7369a86c602362af48f0213d0723bba6ea268b729f1c533375567e"
    sha256 cellar: :any_skip_relocation, sonoma:        "68655b4b618cea505490072e507967ea2d68c9b3ba5933b21337c0546a7cd55f"
    sha256 cellar: :any_skip_relocation, ventura:       "467eef42a568a412696820683ba5bc6ac3177a87a440e97efffec9b2b0ca8363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3382302e955ca05c84e6e6463d740eccdb260d915507286b85271b1319667694"
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