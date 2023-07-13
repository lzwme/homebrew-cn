class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.44.0.tar.gz"
  sha256 "105c243e35fdf7c6d9ff7955aad1fbe400b19d714d9a483c18de3d3ad7576776"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ee0719ddf5e6bc48c5c5399b7c7d873a2dd872953167edc85ea084ac7ce4e42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f4ad42e84e6d5a8439d4a2dbed322e116eb5bd26f187d3c8ecc45fb48272f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10bc5dcaa090e1a12ac4b3e530222b24a19aa8d2abb91a5d1a6a1283ceeb9871"
    sha256 cellar: :any_skip_relocation, ventura:        "f6f42a7d9d8fe10c723acda87e086f50c828e73385a31f234aca723acd135a6d"
    sha256 cellar: :any_skip_relocation, monterey:       "33577329bdd0486f694cb24203dbd621a2284cc15320558aeeb48f2febbc2829"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9d64e040e4d44d81fd39e065f0b8d399bd96d012baa8a3331406992349ab21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acaad3763e312d6ef93e44ae4684858b85ba1476400d5d0a1d16921f9ef58e5a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    assert_match "loaded decoders	{\"count\": 3}", output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end