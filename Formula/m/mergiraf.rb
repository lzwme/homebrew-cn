class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.5.1.tar.gz"
  sha256 "90cff495a1c84bb074b0c0846fe22a32b1765e76de0046e3e444d5a209099086"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c65fb4be282a9db4ce965ea9b175a1558cc93fb0aae4ded6e2c620b3bbe32f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5702957495e2148e9a8e7e65b0ba73e1f8b69c85d1111bfbc6482a5c5f07b2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9b34a9c3b6d40bbbb1d6cedac36ad6ee8f2c27c545d64bbba4899822eedd6f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec622b751feb0c3b8c28c2fecc9daf77ed03f01a8eec9c9a1cc9e332afc4e390"
    sha256 cellar: :any_skip_relocation, ventura:       "66366528bb8a3c98e5fb82ac049256c1a2fc070c16a1189d70a9571483904972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3784d170ec7f11c8005071d1ec3a6e0918fdad9af81e88835147c7d46214ffd8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*yml, *yaml)", shell_output("#{bin}/mergiraf languages")
  end
end