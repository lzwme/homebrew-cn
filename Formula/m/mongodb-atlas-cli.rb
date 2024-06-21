class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.24.0.tar.gz"
  sha256 "6a60c8dad4c64f372cedc8aa76146f40791ec1118d4631b731ce89c164ffa7af"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af68408b4816e8b83ceb6cf49153fbd4b38f09454ff8f18f71c616a2daab2205"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "524438da8095a117074c01269d5a33c6cf7f86e5cb4d4fbe656319e2c3a74dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa0e106fb5c6bdae68bfc8272f8e8b98bc275aa16ca8dfe16197f9abcf9ef12"
    sha256 cellar: :any_skip_relocation, ventura:       "cd989d156637f3b0ec764af4372ed5c19e3478b523ed51e770547893725bf5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "634d8e9bc1ad4e46360e4a3b961bb88e0419543631b006f6567a44ec61581a7d"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

  conflicts_with "nim", because: "both install `atlas` executable"

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