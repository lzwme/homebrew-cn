class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.33.tar.gz"
  sha256 "34a281f64a5a4f0abaa3c231622ed5ec12576d508bf84655a83999816ea1ccbb"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5790f0fde57922e7559977c5a2bba8bbc2c7c299c57745b296857a438f3ee263"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a92eb5308b785268806573e194c9702284d1babf88c671937dec302dfb216bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38b568b308da7aed7394ffb20fe7ef7f752d4fa8ffe35752b5a783af5dfe2504"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9484d28e05200300c761d4f5f549ad2e5c6e4fe4d0a1fba64a1ff77189089c7"
    sha256 cellar: :any_skip_relocation, ventura:       "9363c0f791c71f69bdc203e6411f5927cf6e1d34d7c07fbebabdc258c6f2a5cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44145ca0aa907acbda2f8bb47b3028e56bcbba56d68ae36f95a1f6cd6236713e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd786eccf3d40bc98c397f17619bebb715b0e966626a77c74a90fbd962881848"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end