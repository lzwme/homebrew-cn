class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.45.3.tar.gz"
  sha256 "4ecba876c0d53bf8e3d01ce9940cca7661233329828efd5ea67be345a855f819"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33f8776ffac672deace27801df2166f36043c48793cea74186c1af13af9bd8ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c49f3186f2aac2195372350d05928e2271328c798dba1ef13e45fc19f8e6db09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3b26891b1dede384159a0a055d8725ccbda56938e3d12091000000c2500191a"
    sha256 cellar: :any_skip_relocation, ventura:        "fb6bbee2d8f611ad0b548c80ad0aec7b9b398d73b159fb0537543c3e188a08dd"
    sha256 cellar: :any_skip_relocation, monterey:       "db0a0c987ab9cc46d3064601b0b7743e1f6f5b43bf5db65c0148d664f05bec48"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed0c8c2af92f1f4ef575a43175cfdb23a80883df03cd008e63880a976f056a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b22a8cefe205d7a02082249f34ef40983c9d4c1bcc3ea8b621474c0a8310e29"
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