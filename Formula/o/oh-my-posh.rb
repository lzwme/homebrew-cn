class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.20.2.tar.gz"
  sha256 "ba38bc7f3c76ea23ceba7193233918f96987b9904c4553da7d92477ec60c1bee"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f52728060639e73d5d17991f2f906747387692e9f7708ef484e1727ce8bf1594"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1eb54cd733acacefe39653062139572afe087fda07d73441b8e3610e026bf17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b294d40a75ce0c2c47610b9ba60d086a406daa23a4b707a2f0e52a0ff93a3e54"
    sha256 cellar: :any_skip_relocation, sonoma:         "42456ff73f13f76d18ec6e9ca41fb3314e2ba4ff217d0b818890e65006361c6e"
    sha256 cellar: :any_skip_relocation, ventura:        "8f37d2b0535e9fb9f939386d76e6a22f13efd2296d2068748ded2a9c4df36fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "a109bf641603a84033740e13cf93a6d9934413458b794c52ec1cbe01637e5008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43952b0eded91e83ce21fa3235f698d0c65cff98302025d884b00140024e60a0"
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