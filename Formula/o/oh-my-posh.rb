class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.3.0.tar.gz"
  sha256 "daf52a77ab4b0bc4902edb2b64e16e0841c8698db925a1be80fa0ad23b9958ef"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e730680ad4420df44754959cf47d04c19a0ff28a780a70d782dae48e7beb1b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5a3fdba2455a521d0d72ac2bd0d84ade94ecf306611253677943e71fc96c749"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd86b631485102c5ee1a5f07c2737265bfa28779f3a192dd9441a6922d26051c"
    sha256 cellar: :any_skip_relocation, sonoma:        "77e5e6800bef21dea747e17e7619847d2506303ae2576695adba1c2018324f32"
    sha256 cellar: :any_skip_relocation, ventura:       "1eb1078937bd556df7bfd632f45e61c71d5dee4acb3dd8b5ba26009fe66b27d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "511c659c8d51703f16791f7778a5ae811ab55412b9976909fe1f06b4e970de4b"
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