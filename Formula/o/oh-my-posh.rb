class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.13.0.tar.gz"
  sha256 "1a8da2257ee2775b9ab2fa2b50c8e10f4ed68dc837fa30c49f8c356a57bb24ba"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b1be091fc59ddee0aa9315daa7c2f4ea084d9dc01c4b4c1056752b6a894d544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "670f1a8792bb749a0e9a75aedc3f5e9b8571e1533f4361e8b68c66945c7270dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8356bc3818aefcde621e65979225f3fa7fe7b4acc0f8365d69d6191fa1004e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "429114b69791b7eda1fa3a698bf48e9e70c2f1a63b761728776ee3db8e1d06d1"
    sha256 cellar: :any_skip_relocation, ventura:       "866158e475cf17b754deaee41d0614c66190d36f518feceee41db59221392c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2807455c1703c85a7c40b0456fd759571012fb20301eacbef551acc434f4a4e0"
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

    generate_completions_from_executable(bin"oh-my-posh", "completion")
    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end