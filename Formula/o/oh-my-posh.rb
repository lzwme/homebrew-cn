class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv20.0.2.tar.gz"
  sha256 "70bac4e8280be1fb03c930fcd47621ce4bcb6e983f4956507b09572d558b8837"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86a1125ec2f2847900b52ae476735c51e26dc9768b53d2652eac6931b76c9ad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de4556cda44454f8f8a880b72762d4d134c2237360408731504dafa15a1e9972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81ed3682ce1561063c732c825e0a448625a8ecc91cb21858612903a7f3934e33"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa02527a545492c6e4c06b6eff3e9c32532b0e4394927e92dca4a8f0711e6bd7"
    sha256 cellar: :any_skip_relocation, ventura:        "4c0bd915bcb706fedefd84feda0a591d818f01b77fcf02f0022193f75bd4aadd"
    sha256 cellar: :any_skip_relocation, monterey:       "a9e7df03a480ed1dab5669e6576a1351db31ca2789595ff4584b04402e83934f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df923f78fdd930d8743a5353675f55aaac6e14bebd8c2dccc96b802784e7053"
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