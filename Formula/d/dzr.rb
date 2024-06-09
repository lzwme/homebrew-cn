class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https:github.comynedzr"
  url "https:github.comynedzrarchiverefstags240608.tar.gz"
  sha256 "06ab0eb5ee3e42e0304b68107e6c3aad8842df34a41eb069ebaca4535262e1ad"
  license "Unlicense"
  head "https:github.comynedzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36beb7afb6b802a00ae8b19bd04ce94a0d2cfd951bfafafa0ea878af7abd4fda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36beb7afb6b802a00ae8b19bd04ce94a0d2cfd951bfafafa0ea878af7abd4fda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36beb7afb6b802a00ae8b19bd04ce94a0d2cfd951bfafafa0ea878af7abd4fda"
    sha256 cellar: :any_skip_relocation, sonoma:         "36beb7afb6b802a00ae8b19bd04ce94a0d2cfd951bfafafa0ea878af7abd4fda"
    sha256 cellar: :any_skip_relocation, ventura:        "36beb7afb6b802a00ae8b19bd04ce94a0d2cfd951bfafafa0ea878af7abd4fda"
    sha256 cellar: :any_skip_relocation, monterey:       "36beb7afb6b802a00ae8b19bd04ce94a0d2cfd951bfafafa0ea878af7abd4fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc1ca35f8f4694a4c3a2144e79012001fe140ba20d1952e8905af19da9225722"
  end

  depends_on "dialog"
  depends_on "jq"
  depends_on "mpv"
  uses_from_macos "curl"

  def install
    bin.install "dzr", "dzr-url", "dzr-dec", "dzr-srt", "dzr-id3"
  end

  test do
    ENV.delete "DZR_CBC"
    assert_equal "3ad58d9232a3745ad9308b0669c83b6f7e8dba4d",
                 Digest::SHA1.hexdigest(shell_output("#{bin}dzr !").chomp)
  end
end