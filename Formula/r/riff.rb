class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags2.27.1.tar.gz"
  sha256 "ba52c76c103f7e88301a61227b648d63115e52c7b14ff966073a8d0264f42bde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fbf28af59c487f96d9c3c26e5aaaee8fcbf8c14e8323fedfaf5c7fa6c3e0cd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb53ab33ba318c2bc737c0e28db2292621925f915da4497f0e032b4dfe296950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58d620bbc20c0bad828b8874b2b66641df97af763ea052039287a27fea8593a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5c3888eabe1e26d9df0136eec55bf45b1704b3727283c9e06f6e16790c029b3"
    sha256 cellar: :any_skip_relocation, ventura:        "617fa9a7a3e19cc3ee8b8df0aff15d89cb2582b43fbaf241549e78c701d2db80"
    sha256 cellar: :any_skip_relocation, monterey:       "62f0c6042fcc8630e31fdf4a45c9d0debb27701fb8a2997bab5a7f384a868209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad3a9189aa6031560b59a93dd5ac2438b4651f67f14334e9c057b765acf85e45"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end