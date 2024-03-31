class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.19.0.tar.gz"
  sha256 "a9e8c2c2c4e625f3ed9da53678ca8c14567ad394836795c93adbfdad7a750f20"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c16ee8ff42fd6412986fc986472fa4466df9dc77d09d9f1461426f5c293dc457"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebb4df3cb7e16a159766d2f5ec24c615da1155b206995c335051876d32fbd7b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20718311e87e26c46ab66f868414582b907fbeb219db21ced3c72de8dbf200da"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c2ec606f36e14db85b87556f53ee30d159957bcfc22a94131190a19b5753c1e"
    sha256 cellar: :any_skip_relocation, ventura:        "4e8800ab462ba9e2365ce9b4586297649b2e858a373f5c219a0ecc7513ac03bc"
    sha256 cellar: :any_skip_relocation, monterey:       "67d474e6862e5d7635aca4329df903f5f00e92bd0310fd6aecf64e0ab50a6a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622124c126252b5ece10b0ce1d5ffd3b71320bf1ee1502c885a4377c7585d5b6"
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