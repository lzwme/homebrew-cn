class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.20.0.tar.gz"
  sha256 "558e1c2ca09678bed97f7c3f176707a535e5b7380eb16048a2c0d69b4b6e8b6c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a530642111c71cc390e1e49efbf1cfb91b1b6f25e4ffd0fa4df477c8f5fd410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae3a2456eccb3dd77a2f11b9eaa1aece95e4a1cb18a74517b4b9d57b66e382b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58bbf973e859594fd9fd62df42bdfa5d99b6af58348df8f08652b9b9c61a9106"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c7cf52a2f366be000607330feaba40279c320effb1ccb6ae27131f28f6f75f4"
    sha256 cellar: :any_skip_relocation, ventura:       "b42c02dc1589c2b0297e8427161971fde18cf73bf23b3b9b21d7e7482220b496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c580dec306196761337b5a28ceeee15a59d5e4c701ca1ae085a9b85ff00b5f2"
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