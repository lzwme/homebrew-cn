class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "be3946d6fe4cf2182f70447186e4850a6294cc3097605b1cdbce7edc42058a4c"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c43b9721d9480be13b7bcadec2262d1694e7001e2e182560720e3fca7552aa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e7e6c4a8ee8df0218a8352b561b2616d52e392da0de89bda92bd4f8c0cfdf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb07b3cbdd93927ca4eba514964d854ff450492845633a9eed3e0c8480d992f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3631e661282fc8e9249ccb06ebe0bfadf2261589603a59973fd2e414889c2688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157d024a3b10a49c22fb1b2183a82c62b767b31cc2a3fc24f3439e04770e850d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a021d08adf266df136c934a1122173e98c0af16c4032d5300098fa3c81664c65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end