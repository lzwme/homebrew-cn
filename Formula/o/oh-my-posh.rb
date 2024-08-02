class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.4.0.tar.gz"
  sha256 "d2fa73b9fad0780f8d03ff2bb91e3b5de12386ff43ebabe039de9864d4c84bd7"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "745b307419e7c0f835fc512a8bc9a653f80bc5d8c8cb17c3a23a325286626937"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77eafdb2187afb6c606a0b95cf21b43d950511b9f4953594b7394ec50887db42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf1dd22ee5bc7756e025cbb134a54e276ac9d7a0b5d6ad0f5d3a9bfc8aa62bb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "504ae0c4fe6732ecde6c4bc4b966947c5b3e1d4f15f188a0bb0400162e6985a3"
    sha256 cellar: :any_skip_relocation, ventura:        "15330df6d45ef1e1ede2c69d310e34059ed78b07a28dd224f63d772733caea34"
    sha256 cellar: :any_skip_relocation, monterey:       "39baec7aa861e05893b4935af1abb06a819a2a0221d87f690dec218dfe416eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b694ec3dfb12b0d8889f4067c59a5ba80fe06a65421a03f2c5bf7a9f14e169d"
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