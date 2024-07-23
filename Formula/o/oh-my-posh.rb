class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv22.0.1.tar.gz"
  sha256 "eb2452a90a5fc03f827778e50f1beb9e2242ebd9b2ec0f3d0998899738956140"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3685724c9859953bd5877e49f547f5de6684cf0a0172eb5f5ab7bd09d0aab46c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894415a87ddce74c7a544b06b838577e4427153bfefad8d90fdc0e390af580cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e8afb4fe150d2ba42e9bf74ebd5bd6dbfc96b9ab8f03ce332cc66da9a5fa0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd150f2b935b9f6e197fca3a5597be0423a069c511f25ad352b365a85bd27ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "ffaafaf8b57d655b3e9db8bc59a4503a8bfa1170a88806709fe83339ebbc9819"
    sha256 cellar: :any_skip_relocation, monterey:       "22ce3a7acdb93a384e7171380fb661a7111a82cac073c0095bbe104e271afb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc20049c02d3c9a7fcee5519ddb1a0d7d9adca5cb805df4f90ae997af4a496f"
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