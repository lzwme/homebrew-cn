class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.2.0.tar.gz"
  sha256 "4450fdf8e94a58c0dd5ff320fdf4457c448d899e1b6c8b42c1a963acab972423"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f12d23f4cb98b58626f04d9463919b285db384a0c738475732ba2a9947d4b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e87308d70c9fb980e628341b0d4efbb41a4f85b45f70ec7c21d10f95899dc1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59e5e83487ed1cd85c498153be26488c5e5c8767ceb8628e85dc9bb12718b035"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d87610f15e8e2d5af7df82ef0b4daa8fb9736de5aa5c524ccccd104df2fb935"
    sha256 cellar: :any_skip_relocation, ventura:       "c04117eeeae9590cc6c4da809b12404079b81502ab3108b120767fc2355d7b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81f0fd4499eab8d615d8bbfbd6fd3f90d338f1c12b75398ea1a0c05b427efd32"
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