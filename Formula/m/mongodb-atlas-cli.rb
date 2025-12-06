class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.51.0.tar.gz"
  sha256 "d1ae13a071f9d4959819e486014086580478d796a487264ebc57010470c51cdb"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31b5cb49c893c32baf89ec1cf6f34ac28a3760b402d4c49ec03914d902093831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7974d5a4e7ca06a95acb6653dc8c1b2879072d9ea1fa2e8f2ed31f36e650db3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0073588cc690259dccd6e6f08cb0900c4cda3b2eb7f593370ae2bd06a92c9acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33a0832efd3a4152326c75f9c2b44e6dfcbfcba2d0f355cbb312c131f46b934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac4385f3f8b7bfb9703d5aa7934d7f9d75044fef5405c8b00e99ac3e06b0df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260a8ff585b7d4703888258480eb8ef7c798c7988f090df69e627ba0b5d08286"
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
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end