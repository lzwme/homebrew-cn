class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.45.1.tar.gz"
  sha256 "04b0c26e8fb2f22d0fbaa1577bf2b5a5e44180936041057098c8b6a0e38ccaea"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a0d698f471326156c77a04c75d348ddc1759e4b0e382c743a862d4a077a5daf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ff26f46f68e198903e168e27f38eed5927c5300a207d66cb87f98a883e05a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d38fe4ccae0451a74f2cab7771e73b1da6da2933572c04a800c863fdcf09846"
    sha256 cellar: :any_skip_relocation, sonoma:        "8504514ad7d63fe9e02775ac14364ac91ef82f21c0d3b9e15e270cdf54e371b2"
    sha256 cellar: :any_skip_relocation, ventura:       "ee30eb4db2c4b64d2a4d520eb349b250d33831c4911b07aa08d357feff160270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18cc7497c6c90671c1f952e3633675dbb10d72711b001c4cb2c16277be5a728"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end