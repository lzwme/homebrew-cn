class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.45.0.tar.gz"
  sha256 "5679fd0f4929f497baa6ebbb262f08d649f8b81cb91fa84bf1aceeaaf7a8c6c8"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae36e5f747b6a340152d5e2c3e5713c8d2efcb653ccc5db0ae349a77a3a8593a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1d546992ba66a026405ac8f61ff16667dd801f2506d3c40a7ac71d5686640f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55aa74535072d855fe3059ac1775d110ea5c04f2d5fedad1e1baf456398303a0"
    sha256 cellar: :any_skip_relocation, ventura:        "0e8fbae56a1955d3fae9686e740463a758e03f7ccace5c7d6c9d4a2bd4043af5"
    sha256 cellar: :any_skip_relocation, monterey:       "806918345bc8b10f682a81391d88704cb637830cbbaa2cb29e8e2951d53aeb1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a8b3c1bd5d8f3fc8dee2c1418c23c33a8c0ea304da0d47ed4c3c91ebc753d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9c17c236c131867501b048960d664296063fb444cdb806b4c4e64189a06052d"
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