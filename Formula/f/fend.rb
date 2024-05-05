class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https:printfn.github.iofend"
  url "https:github.comprintfnfendarchiverefstagsv1.4.7.tar.gz"
  sha256 "a881e210e07ba1c3de1a89d755852359a636afe4091de65c4846767c69dd7f72"
  license "MIT"
  head "https:github.comprintfnfend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ce4f9f48bc2daa7a379d8545511aceda6a428cba5f844345778ebceae965bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5f769216dc80fbaf435ec4c0cce2f1ef7c850bb00ff13580612921c44b88b81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5faec01e3f97e1435b672cf4131b20fa7ed39a960af1bf8bbe925d1e8ad778d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "846828b2819365960e459a3c99df6685c41802add35fc6923319714d14945e35"
    sha256 cellar: :any_skip_relocation, ventura:        "8e3de75da5113f0b73b38ffb6b69b90cdf58bff06a65f9b065f8de9a6a99f655"
    sha256 cellar: :any_skip_relocation, monterey:       "e8466c5cb4dfeeea251a373c2794d3c56ed03d03bca1f5c20477759b5c616723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a38789623263f8b2dd01c36851a1e707d46f844906120604ae8906f10e2f75"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system ".documentationbuild.sh"
    man1.install "documentationfend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}fend 1 km to m").strip
  end
end