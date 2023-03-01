class Unison < Formula
  desc "File synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://ghproxy.com/https://github.com/bcpierce00/unison/archive/v2.53.0.tar.gz"
  sha256 "9364477df4501b9c7377e2ca1a7c4b44c1f16fa7cbc12b7f5b543d08c3f0740a"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ecca599dd555f8bf39177b3d69b4091a60391adc88543a54f33949309ecb4f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4482f0925510919ff323ad11cdabd5d72cb57bb7dbfa774ae229aaca19efbff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be465eaea4ca2fe8f7e9d9c7c28041b4578b3426987858dfbfe9f72fb8b74e5b"
    sha256 cellar: :any_skip_relocation, ventura:        "02b73011fb3672256347ca6af3c4c59f5bfecb586c609a678290a563c772a28a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f944c773921df6d29441c3901089432022476b7c1985743ca25f2fbaac7ca6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "61aeab9ca513053c3eb6899ab0ce49574462b3b03a3749d6aa35fcce98250d9f"
    sha256 cellar: :any_skip_relocation, catalina:       "9bedf63a15335555b43b3a94cb827cad73ad107796c7c878e177dd281a83d2f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303b4bbdc40c9171d22c5fcec4b5b7a0898ba791b9b0a06b37abf6c853c6e032"
  end

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    # unison-fsmonitor is built just for Linux targets
    bin.install "src/unison-fsmonitor" if OS.linux?
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end