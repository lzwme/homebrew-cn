class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.4.2.tar.gz"
  sha256 "f74aa730350545bc2b373040be6af3c52ef194bf868c95ebd289f4a0df90509b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ec02876cd586e406044999ead4703c71e849d6f9d7ef3fe0c8cc2ecc2bd2216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b001b22ae085e7ac83ae9a122b21e9b9e70cc8794e592c6ee85d1fbc3332e33a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b12f70a2120304997873544dec13d638b04aae8cc87dbd34b0f9d4e2c434f1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d7b7f17eb700392955d5991260be44737257bf376007baaccbe918c54849ec2"
    sha256 cellar: :any_skip_relocation, ventura:       "c998508221e1ba10f3687911a36a9c0350fe9ef6ea902097db087f2f478294f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "760fe037001e5902c0ad4e53c2431ef1054d3600990f817012f7a8a4d0489906"
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