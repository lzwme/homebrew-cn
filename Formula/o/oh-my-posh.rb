class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.15.1.tar.gz"
  sha256 "749ae1ea4a02334ea01714ccac5cbcf8cf98e49397985cc35311ba5b157480e9"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5971df2bfee413a759b490da9c9c63d08dd56cbed93c3e756a8e89efd843e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2919174f44e86254b0a068ffa43e1380de6d16dfe77002ee7bea37d3b47882ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d7dd6553f4aae959921e1663a6e95477c030a833ac9318af4930d91252a16e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b34fee03025f6fb5453dc366288487ed1aba9ead81154701bfbce7a7c4ebb21"
    sha256 cellar: :any_skip_relocation, ventura:       "c99ff2753f9e85407a424c0a36be1ecc2c56f771b7cfbb182ed96ea748e2369f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e250e1c07987d9d7e81b550970ad756750e01589a3b650057b69d1f6064a073d"
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