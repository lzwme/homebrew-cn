class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.41.1.tar.gz"
  sha256 "42e287d84cc9bd2c1a5f4cac4ff2d88c986b6519bd3b8491ba5b5646dc6ea0ee"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b571beb63ddbcd346de55cb33504278231b6573a1e6ee622ad1b6cc6d5947d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a29867ce28d82e2b4ac2078adea1b41d483a895b3fc622bf5c03b704901aebb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f28a1063537b0083395113308b239ea5fa0763edf84b9f9cea9d26f8faa4ac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "752bbfe9243d42ac73afaa232e8995f1cec9b6157be2960f4bee9708e2fdde70"
    sha256 cellar: :any_skip_relocation, ventura:       "9bee7042f6a947ed1f743fc510fbbd430613f53ac9aba75fd0a7799d10bda2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de53ce5a12acea07d4323e55b0401f853e8adc3bef7f1a247ba54b047baa17b"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "binatlas"

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}atlas config ls")
  end
end