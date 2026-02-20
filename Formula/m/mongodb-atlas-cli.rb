class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.53.0.tar.gz"
  sha256 "31cafda4789626928af8496a0b077a81ceae46d4aed473b9a7db5dd4f45318a9"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77622888e71031c106f3b43de1511fdcf34e6503c227790d440999972e480835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61fb8279fbd66cf220455f41b707871768df7afb95a91c0a829c40a33e94f10c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f44f84351a4e16b13371b6e7f96426d887860d2aef03f6ee354baf26d349eb83"
    sha256 cellar: :any_skip_relocation, sonoma:        "377c18eaa3a3e11d590a35ca0ffdfc76ba84515ed6a6e9e6a2530ad5a2584649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "055d7eb7ab1469580997ac8c3dc223105c2efd263bdfb06613be9dedb66928ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946b411f44b72caa3338b5bd30efbcaca9641f2a26516301e2ebb88aff89e687"
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