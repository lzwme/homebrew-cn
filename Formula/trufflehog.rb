class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.45.1.tar.gz"
  sha256 "147f25bec30648581978b5db88d5c540ed56c5efa5dd3b5ba47a2acda2777a3a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1a525d1a3ad3580c721eb0b675e5ce4f83b038df8391e80f82ba772f5dc8005"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "863463d5ba7a87ed245efc3fe43eeb8b5e2247cbeb4deab5f29164f9618b9437"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be5b2d3173c8bfabfc2fddbc11ff775e9fe2fb70365d5bf0815a464d63dd2087"
    sha256 cellar: :any_skip_relocation, ventura:        "0f94ff482077ff709f76066b1dc1253c1b60ed785db26e4003dd3cda1a321c01"
    sha256 cellar: :any_skip_relocation, monterey:       "ee68ea6aba763c790062ce27617f7be53be49fc0ad06abe3f89034417f8b9fd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f29591c621a9e9a112940ce3c9b42b30cce9d4ba5d0343191892186d633c2762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092c026355774b6a5502306f941576e6a3fcca75183117e916c38c46b42117d9"
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