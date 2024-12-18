class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.14.0.tar.gz"
  sha256 "0755aaf80398d4c6cf1adbe179e964d31ad0536dc2d728bd0b389327e993157c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af8d48af91fb5a70be1c00384652e7c621e00659ce4bc182f2eda1b1015ecac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b471465046890578bf2498047534517d8e3843bf158fd37d1a02f4bf17533c2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48903f786cfbdf577f121a5314d62cf2d636af4d00c9b4955056076ea90d3a97"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b761b72c46e402fa07959a537a23cc998f6cc021d3e9db98c0838c2d955925"
    sha256 cellar: :any_skip_relocation, ventura:       "5d73043780ff1a2d97a1167ccbf401532fa31401468e06597b00fb530dec8ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acecaad8452599765c0cf3d46a1907251310cbd39b7152030569ed00cd91aa94"
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