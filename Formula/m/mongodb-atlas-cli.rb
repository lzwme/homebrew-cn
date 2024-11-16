class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.31.0.tar.gz"
  sha256 "dfca99d7e94d584ba55385b4302489b098152721b55cba615ee601a4747b5df6"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7e96a1a65c98345d442d5b2ce262954bc81db69fb02d04878e13d688f53a893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6426b250a5fee6311ca39cdaa8233534b60d81fdb0454efee4b754f39f84fafe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e54caf0adc89f820076846b8ede3a35290ae12627285d0a104e8d541c20ef62a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5067554eeae55c7011f2d980977f49c84ae1e2aac8cf329bca836de6a912b24"
    sha256 cellar: :any_skip_relocation, ventura:       "c05b44c78034eeceba85188668befc19a815e5292db5bbe7725d20fa90513b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2e3d30e55fb40f51b4774704dc028efef0474b96b7257470d48aabee810651"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "binatlas"

    generate_completions_from_executable(bin"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}atlas config ls")
  end
end