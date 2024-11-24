class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.7.2.tar.gz"
  sha256 "b601f7ae727ec4b684deb641a01c275932aee40e962334ad1995ac0e4ab0a38a"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99dd9b9a62836463d584277b6b7bae8fe1e037d42530e5e7aac2aa90e0bb085f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a9d5fecb646561e27a8a24400ad917b9763ee4a402ff1303338e5cb9360220b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8d97fe39fded58637413d3f6072c12a6be51f9b2b3fca5137dd90475b8817f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b25c637e67c3fbbca1bd58d7c1d31d29abb0d2e49c7161ca260879470bde8a36"
    sha256 cellar: :any_skip_relocation, ventura:       "44bd7483c362e5579e4d78aa3bdb08d72d0a64542dba42349b7a5ce5f45c343b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a436edea77884d01766f6c003370bfabeadacd4963066454416494475099d33"
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