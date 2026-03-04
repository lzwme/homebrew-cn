class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.85.0.tar.gz"
  sha256 "cabeba88d4a47efdd5b2ac2d149e0e7ed18e4fd91c33e534293795cec11d9d27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bc22b24cbf1ae59dd19e3a938b4ef304b430f2b394fc84521a314c1d32c93b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f1c8e40c7e6c1624ce9907b2c4965e3055e960726c22d01b917b4edb648164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56fda9f5d113ec5769757ce70f8474e724631b2c60c60139463b53c2fc85af3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c004a6e12f13ea9cd2f3f274e3223cbcde50192fa54c3875debed64218928c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dac32a1a53fd98b8b532e8864fa47818b05a3119f4577dfd9478de236cf91785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee3e1278bef0e3c65a6855fa7226636af67f2ec3e027d47533b64ffef3227f4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(features: "system-alloc")
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end