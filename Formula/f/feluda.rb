class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://ghfast.top/https://github.com/anistark/feluda/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "3b58e78c4d8087db648c420b76a4524af5644f273da23bf728a3eb505b90f211"
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
    sha256 cellar: :any,                 arm64_tahoe:   "8a014a196f4b41922838f02260011b1e2c04221924886c8fb2bf3cbcff849eb1"
    sha256 cellar: :any,                 arm64_sequoia: "80acba8f26391a0682233171d7924bfe8d151e4ac1d69eee0fb8c3ce55bd3b95"
    sha256 cellar: :any,                 arm64_sonoma:  "4de49ebab0ac63400cc593bd071962538c68081b5a793ce62d8450f65ae8857a"
    sha256 cellar: :any,                 sonoma:        "32d52b228acdef60a9c2eb7212bc2587d54f57845436593239384ae77897e937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f74489c550e22e1cf0f7f369a18365123279945c9ffb86263ac25b01cb91368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b685e65846906f66720be653f317cc1ab53d237eb1ef717acf4ee3b75733dbfe"
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