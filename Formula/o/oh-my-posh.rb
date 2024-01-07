class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.4.0.tar.gz"
  sha256 "fbc44e9afb243e5abc473413cb02f73d3fa3cf645dc94fcee5f212004f239396"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dea6b93d47b783603acd15ff25dc8a92dc6fbc519de1a92646577c52df2df880"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1cd58f2f2966f34d44eaf182db43d58bfa239f2be71e3564944c6b5b2cc4504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "262e3e68cf0b00e72fa48a10ad887267eb64315a518d447ab8a087ce983d6a38"
    sha256 cellar: :any_skip_relocation, sonoma:         "caebcb7578aff0b5e97dccc26d9571f6e831484338e416319eebacd065a90cd6"
    sha256 cellar: :any_skip_relocation, ventura:        "fd7ac39662fe821a1001c97d083334c104984d16e3a4d7a66e45b790b378bccf"
    sha256 cellar: :any_skip_relocation, monterey:       "90c7b898bb764764afb85dd382146a86b7466e4b4c54386c9b08c01766d4d7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b5f60c155a8abef361eb8555d969cf69348b8b1b9cd0cb0962c98feff09b180"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end