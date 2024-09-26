class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.14.2.tar.gz"
  sha256 "71e85ee9bb6d456ca24c673b4a6479ee04ad5dd9630f674df868ebca10314b1c"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4451705b5bb64a9c4b525545d73f7bb8e76bd628bf467bd6c2c875b6f03f0a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "072c4c938c9a394d7438cece7f2ae2966a1a31e3ef897ea5b6ef626cbbf08e2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaad3e2f2b9e7d9d206f4be4a436a50bfb3796240586eefa3ab3f3ce22fb673b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf9d8b616ceb148c55bd3188c8694f35300d31189616975e057056c1aed6241"
    sha256 cellar: :any_skip_relocation, ventura:       "9cdd4f3d3287fc8bd55f69fd1979afba0081f092418d193f09978c9b1b9be942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bf672d432306e8de4ff14e2dca43a7f5e8b88041f36b9643463eabd228dd2f6"
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