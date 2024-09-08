class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.11.0.tar.gz"
  sha256 "862e587cfa9f5bb8a7283f5748e5d42bfbbf08814eb5f000a06c8056479ae796"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "247d73a0e6c30fa29bb707e92c0c6dc35871eaae9c1eb679d5c4d008cb2fe755"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "948815fefd5e9cd7abf432449bba87a10924fd5b4f65d09f6121a99d239ba965"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3663ef64aab89c0b5cf92d91c81433faffdf908044bba324d343d9ed75d0cdf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "387dc191b54a21354a8fdbd75f9088ae5d4ace5c430ce7d5c4bfd02f7b2d9908"
    sha256 cellar: :any_skip_relocation, ventura:        "e04b02091866ec340224ca4bd017b6c14faf9ee0dd512a90e7b664f7814d8415"
    sha256 cellar: :any_skip_relocation, monterey:       "abaeeb307a1f51780da53b7a1d62955ebba5272732d0920934e10a4c5f9bea5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b5ee4f587cad6ee2670679969f5db737d67721e78fb4acae4cbeac4b03b85c4"
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