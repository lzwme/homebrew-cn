class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.2.1.tar.gz"
  sha256 "2597a91f389c71dd4bf6cee966a9adf273c537ec6a893fa0ae34921a22e8ed2e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83d1613aaf401cee7231b92734a0b89dcbe6d84733441ef537a9bac34a09192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7009a8cd13fdc99c8b04f148a036b35fc40e028ce7360aac40e99659bb92f7f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "649916d0561ad5177eed8477b9e32ddab9c414586a0a833b680f5697fc9d09b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff6cbd945d91a545993a175f7e58d84b0e1d561efa39fe53de866d7947eecac5"
    sha256 cellar: :any_skip_relocation, ventura:       "6f2fb28638da19125d2b937f7f9eca82c8e5ea04253ed4635d3249d4737a7d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dec54750ac853d4792189ca57b62d4967544ff01d5f745dd048da0d67a8a2d1"
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
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
    output = shell_output("#{bin}oh-my-posh init bash")
    assert_match(%r{.cacheoh-my-poshinit\.#{version}\.default\.\d+\.sh}, output)
  end
end