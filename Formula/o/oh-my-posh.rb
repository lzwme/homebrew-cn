class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv20.0.0.tar.gz"
  sha256 "302293a0677abc9e7a9882f67c16c9468b30188bd4e2f9de7f2534f4e85ed32c"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca975f6918dcba09749823d49b5ffa23f3591a2a25738350def42488abc2d6a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4df5028d4eeb943d40862e4e3a8e6235eeedf5d0f26efb7629d9782b7eb5ca70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c69c634c6d78edf491a4328faae1eaa552f27abcd5f202842b7b5e32f4c4ba1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b006a0f10444d42a80e9558759a344073f40f73b14ae3ae5643c5221a7c2608"
    sha256 cellar: :any_skip_relocation, ventura:        "8b93308db9407b838ea4b0261a5d10b84985605166fb6eeccd6d519edae7edb3"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5f721ac33a0ab46a70fdffe0f995b5f9e20161c6ce3d28828979d465f596a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fde18ebcc2fbf3d6c5be4d58eacf7fccf733707bf0e1e1cb95e44674bd3fdb6"
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