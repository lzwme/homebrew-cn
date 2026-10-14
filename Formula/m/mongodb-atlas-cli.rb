class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/v1.59.2.tar.gz"
  sha256 "c1e01f0f95e7042a7a7791f8000e9207d37ce05fbfa06f9834d25c5fa30967db"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab25d1b979e993a745caf97d06d0cac6553c1ab9a778c1186e4afd46e112fefa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffdd992bf5d362cab96af1b2e6828697b383fcaa0ac9824cf7990c5b6ef5a7af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ce9851ce73849f0a0a2c6eebc94525968562cb8fc618b63c60e665151c0e433"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "54a71067c0eac48b64326033d6b4987c13986c81f4ee4d03d8d64cd60287c6b0"
    sha256 cellar: :any,                 x86_64_linux:      "f941129ad681a759e53f35e5e361550fe1c687033cd3d2bdd9fd4e9bd9456ba8"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  # `test do` block expects an `unauthorized` error from cloud.mongodb.com
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end