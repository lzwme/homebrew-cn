class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.59.0.tar.gz"
  sha256 "133c1ab38830bf4503382feda58271ad1aa8709c7a5fbe830faadec4cd102bc8"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b063a7523760fe0293d186229c93361a866feb188eb89e8ca1e0cd2b02a9bbf2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99db09b969fbee7659e4af4140aed47b6d024358ef7afcd1fc61873f2f9dbcd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c8a405aa750295adecb814312a500c4207ac5e861526bdfe8347db4c41e633d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9936ce3d743242a60ab95fce367a8147cc7750e53cd88f06c0c857b4250ab897"
    sha256 cellar: :any,                 x86_64_linux:      "2c0dad6a8b8433093dd30cffc46a49317d5c15091d52bec4b1b823797178197f"
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