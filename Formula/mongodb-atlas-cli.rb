class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.7.1.tar.gz"
  sha256 "97fcb683acc2c19042c44a8297bf8216a2ee4b01f0a81058434971f2ca95a137"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a25f991138db19b59a831f81a8a2c2d501a738a573f3282d5600daf9a8378e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "442e8ed4968a8fc92ff50df96fdbea266ad5045b454d61c473ee79d81d18f9f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38b5f26f88839784db23168e1aa5314475e9cf49241a452f8bb195d9c8537607"
    sha256 cellar: :any_skip_relocation, ventura:        "666327242dc8bc3bc1df6f06c7b53bc960f4b9d5db6c0b6dc655f412fc6a4994"
    sha256 cellar: :any_skip_relocation, monterey:       "a7d0b0df00c41780f352ed375c72c0cb4c7476f5abf59fabd232832c97124ce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f124bad70a69b1075fecf72e9a97b73f44b46a3323c515ec2ee4a268df7677b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf8af130cacaa45d5a6927da8a67a3b25d9ff5e2b2f16514cc6f9f8b143b317a"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end