class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https:github.comSchnizfnm"
  url "https:github.comSchnizfnmarchiverefstagsv1.36.0.tar.gz"
  sha256 "4b164d320f9b68011ab090ef77d2ce0f40f659278476113bc6f00f95e79444b6"
  license "GPL-3.0-only"
  head "https:github.comSchnizfnm.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7524e4ff862f8c64d9afd23e78b524b49ff49ca90b3f53ccc080f7b05bc052cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b24a014a6eeebfd655e04daccd73428312ffe912a63e392d1f874ba760c84e33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd445bdafe46a600f5ebdaab88fe2b490db7801e5613cb03b4af647bcfdafd47"
    sha256 cellar: :any_skip_relocation, sonoma:         "87daaed717cdba168551427c6d6fe9ed49f6b756c1d3f5ab4a6bb7196ba943ae"
    sha256 cellar: :any_skip_relocation, ventura:        "2ff0473e8584f4b63c1c6cfc3b63dbda75ee231ccf575a558541185fc1488225"
    sha256 cellar: :any_skip_relocation, monterey:       "3b1c6e4840d4a5b4103157eacf1966ef4a02c7038624bdbc6136639fbb7a31e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da20b131b1706cd1dbf63bcd7c0320e6f9d2ca7fc0fcd89eebf12d3dc554892f"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"fnm", "completions", "--shell")
  end

  test do
    system bin"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}fnm exec --using=19.0.1 -- node --version")
  end
end