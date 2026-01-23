class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.51.2.tar.gz"
  sha256 "87bed5a8bdc6c823d25d8ad04132a5de89cfca22df8af9949beab1e5e7b2359c"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c01433a06c2c8dff54e3fbeee09c0f76b95cd38b15aab8c806cdef3ea026a2c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f92388f38bc8a30de5421b96a29c1c98f7d9b91f59121a5d0a597bd0f1c02d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e10600448c211b1894beea84c0cdf6c03b18888feda545fa5533de88e4c21d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f33c3ffd2cf671657dbffb90e9f46166d88ae0683ca11b2e8b12b3796e6d8baf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c4f5e9f3d2dd487f1adb784a492d9a6409ef92014b3f20db737c114197d0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace20f9245ac0fbc8a11d7adb6bc58dc78d9009d60813cda9ed90d4435e147cd"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

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