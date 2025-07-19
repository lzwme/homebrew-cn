class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.1.tar.gz"
  sha256 "4aa49ac906337a62969469565640e9b20530d8adf6027dddc7f101d0522e5758"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a771137bb93598247222f4201980c33b7c5a9efbe03b0a7ab8a386955db4dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "737e1ad96a477c8f15a513121deaa0ccec0cb31947fa36f2dc6fca759cc1c091"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94dc2b41b8ce60b195a7aaed21bb40ef6277d514ead8866ee4f685ba5be7b904"
    sha256 cellar: :any_skip_relocation, sonoma:        "1485684c36d2bb9014ecdf64a5e15160902251f7f787e454ba73dae1fa258ba5"
    sha256 cellar: :any_skip_relocation, ventura:       "31a18f96fd657d83617e0c67152c6475267ecb684d47dd26522e7ea6605a03ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2472580ac17eadac9121221413bb4c99200b2c3fdac3ebf248300c94493a181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706d482fbe51d20dec758d698b69072775dc4ee50daa1e46dddc471589655a2f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end