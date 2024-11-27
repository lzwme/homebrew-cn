class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.10.1.tar.gz"
  sha256 "66e492ae0460baa3e205566902f40ea8a40661de4c708b38310dcb61841cdc0c"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43aafb2499d4da16fe29681dadaf70628878c5bac33988732de0604de900eb6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6757d997d0065f573411d2486ca2ed764fc3a510a5b5903eff6ff827c712dcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "165ea0a07bccf2605c6a4f331f8ba278b7adcffd94656f6cd38a59e4005badf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "22c755180a5688e79cfef2290ab0d8fad7f5d99b7e80c8203cd434a64bd26a14"
    sha256 cellar: :any_skip_relocation, ventura:       "fadbf74062f67f9c9a9c2f2d74d96d6b3074af93a2cb81852d09dd0847766ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2142307445f8a1fc1993b561638065ca9331fe861e90a0641bfcf5816f41db89"
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