class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.14.2.tar.gz"
  sha256 "3ed9aa23d78d236fac9348c824d3a0937c524d28f99a2937d4b31ff0410e8ea0"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2b4506fe257cec77b3725eda04ef0e0b4bc33f5caa0908f57cb483794c44d97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "059e1a11051c222aefcb2e275042d55e6301f60b597344d9969924da7408e7e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee5a09bf0fbc8237c3cdba209c7e532b4234186f63bd87590bbb355fb52c6de"
    sha256 cellar: :any_skip_relocation, sonoma:         "308eeff899379edb70664a055a3fa9d4ffd3a49f7c64b230756368c473b2c08a"
    sha256 cellar: :any_skip_relocation, ventura:        "97386e30722188cd4ffb65afb4f7500cb8aa857036685b6ed8cf52abb2a4837b"
    sha256 cellar: :any_skip_relocation, monterey:       "11dc5b9604f34324da10221bd927df73e3c4884968059472f4febbbf5282c206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ae4ec682e833949382261b52543473bac4f912ca0878d8e5ce40a5158647ff7"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "binatlas"

    generate_completions_from_executable(bin"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}atlas config ls")
  end
end