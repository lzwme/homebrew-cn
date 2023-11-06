class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.23.2.tar.gz"
  sha256 "d5503734b50c865bc6ac2abd3a72f09172094db54fd11372a84b00a3e107c859"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59037324a4304ae8cea1f9040d84b7a74727245c66ff71553ff60f4573421137"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c33c792bfaa65f6221437053afc884f6d37d99876cd4aee796de5c7693853be6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85298a48fa377b4dd6225cf866b783f2ec434e28c1df6b6aff820a7033f50700"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec726434b50aed8c57215738fee0119838d0a57ed366c56283522b76746961a2"
    sha256 cellar: :any_skip_relocation, ventura:        "778ad924892f1f719f232212e915f3b86ff3ec3db237abfa5008e1a5aa9659c9"
    sha256 cellar: :any_skip_relocation, monterey:       "b99cf5d8b20f948459193a742b18502547d51f6232df26b5c50c61fc463f0dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce338dca298969cb48c7c4537bf3a390f5b5d7cd698fdf156d8ba944e5810ced"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end