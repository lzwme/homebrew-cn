class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https:taplo.tamasfe.dev"
  url "https:github.comtamasfetaploarchiverefstags0.9.2.tar.gz"
  sha256 "0debff1ceede3ca57b0eed98b2dbfd3b2f32abb74a3e5942acb1357c2f249314"
  license "MIT"
  head "https:github.comtamasfetaplo.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple products in this repo and the "latest"
  # release may be for another product, so we have to check multiple releases
  # to identify the correct version.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16ef0edc62e7d1ebb0bc30c97c6685b00cbbe0c6d69f35d4ba260b6150239156"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2459502c0142857600faf038bb8bf81611874807e2bd4e8bb73cd04a91733a09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894b1c0234ae49229ab11ff33cc461e81a4a8e8b7857bf2379bccfd46cb7934d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce85a787ee246a3062cd7358e522a51bdac9bb44229a7c7cb8f0f54a6f004445"
    sha256 cellar: :any_skip_relocation, ventura:        "3af02442ea74bed751355c875ea1fa5b666d6348bf7f87305485e07729f1d5ef"
    sha256 cellar: :any_skip_relocation, monterey:       "737652b3ea0aaf42a5b0fcf0a219e37df4f1b39f8ff7070bf9c759930cbcb340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe7aec5f9d4d1dbfbda5c02aba68d2e03f4d2689a9cd8e0f6bd3bda656a30cd7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "lsp", *std_cargo_args(path: "cratestaplo-cli")
  end

  test do
    test_file = testpath"invalid.toml"
    (testpath"invalid.toml").write <<~EOS
      # INVALID TOML DOC
      fruit = []

      [[fruit]] # Not allowed
    EOS

    output = shell_output("#{bin}taplo lint #{test_file} 2>&1", 1)
    assert_match "expected array of tables", output

    assert_match version.to_s, shell_output("#{bin}taplo --version")
  end
end