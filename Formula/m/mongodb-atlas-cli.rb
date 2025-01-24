class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.36.0.tar.gz"
  sha256 "0965197a2cae73e55a18eb73b6f6f13ddc41d8abb6cb4dad90571434ad325c2e"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d28aa87d844f190dd68536bbd77a41e44bff2cee1dca9f8ecec532dc5caa4820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6410b8a8672da796dadd3f922db88bd7afe8d59d3e3fb995648796cb67dd857d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30335c74f810500376fc6a643eb1478ce59547d8a9a03ffb7bf247a331925d5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4926e7834cfbc1057ab2ac948fbf68364b19a95ad2004f802985672a0755293b"
    sha256 cellar: :any_skip_relocation, ventura:       "2fe4f237e3d7543722d2915ab4c75ed570b0d127020719978966808e5528c51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17014113312f703631d1dc2e4119896f2c7aa3306ec822d3ea5b71026b86371e"
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