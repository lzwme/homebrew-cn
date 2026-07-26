class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://ghfast.top/https://github.com/anistark/feluda/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "61ba05bc4caef9b945b047386b6a08d9fecdcf4a2b2a2a109e0e6686243b5760"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e7391165c39228f7924168250881732799ffd854dd5eaebb5890544b588fe8e"
    sha256 cellar: :any, arm64_sequoia: "721aa2727317c578e5c13d97e711335eac7c98e619b6b3978bacdd0f31b5ae7d"
    sha256 cellar: :any, arm64_sonoma:  "4e3cd068b9feb8a51c939b1b4f9ba348857c5b20a7d329adbc30b01914f54f44"
    sha256 cellar: :any, sonoma:        "c56371784efa3e8da193ed536a150888f6f559fcdac7dceca23910617c934dc4"
    sha256 cellar: :any, arm64_linux:   "57b69386cf94964621de8884120a695c2f522d8ebc975675f305b782fa13a931"
    sha256 cellar: :any, x86_64_linux:  "0a2046a95b2f1273a5f5abbabe8a160fd8768abe2bd3c3bc8aedc880834c9c75"
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
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end