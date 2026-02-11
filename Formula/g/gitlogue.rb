class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://ghfast.top/https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "57b1c7ed46bf989cd32c274a4e59469661f3018b89ba1cc01c0a0c964495f426"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e03bf6bb205c97c1fae75da1102ac98959e749a17868f50952c995d7f8b6d345"
    sha256 cellar: :any,                 arm64_sequoia: "5ee545bd94e52a3cf8eb7072cbfd5ef032bf57f5cba485aa9fcd4efdcc6c1369"
    sha256 cellar: :any,                 arm64_sonoma:  "b9d6e95ccf83b0af29b3e8549ba29b43fcdefd698a5558251c69c62e4c7aa62d"
    sha256 cellar: :any,                 sonoma:        "1b4ff35275e305844fcca433431c3203f99dc24a030e0669c530af9fc2b5868b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e1cd488a243269e01506a901d1ecd51de77eb61a797bec1cc2ec44cc7220557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c88c12baa14f3d877b2bb4ec9a5ad5f5160acf6d9d7f544a858200892441ce"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end