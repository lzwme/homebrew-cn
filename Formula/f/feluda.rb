class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://ghfast.top/https://github.com/anistark/feluda/archive/refs/tags/1.9.7.tar.gz"
  sha256 "31afcdd2a822ebd74bca98fc9d0f3b63e3b36ffd6a7497040dac37a00e55aefc"
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
    sha256 cellar: :any,                 arm64_sequoia: "beb7e39a620102aca4bbf4ff99649d16e0c497ea78cec50cb9478842013cf96d"
    sha256 cellar: :any,                 arm64_sonoma:  "6f411b8e372d99f99189394594e21dfcf3081754d9b4c44637bf790ff21ee2db"
    sha256 cellar: :any,                 arm64_ventura: "6472ec97eabe8e98a692086ef80b137c6eaae1757d99aea65e163f35d31e1eea"
    sha256 cellar: :any,                 sonoma:        "e541e0c2a66cd3bfcca240d094f1e04595444822635f9039fd51d046bc08ffd7"
    sha256 cellar: :any,                 ventura:       "c293a4b76f885d32545fe78e60a23bfd3be87b25d4da6f56c8591624c14bd752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de3655a3d0435ecbe5cbc8155c892f61b9b4f26ece47de895962e5863bbc0706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4900a3f719415074f59f05e99ff8bbc3de1e8b93bcb3e78978a1a86cd60fdf95"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end