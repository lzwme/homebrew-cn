class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.44.0.tar.gz"
  sha256 "f7f6e48e89047775fd90de3f8c8aae3f8860aa846b50882b8f7f3bcbbe726dc5"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0207023b9a03516878d93089c8581dcd64c0bc7ce09b8380ab45779cd22c24f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79466f7f50ab8d31ec934ac47b44ca55774751bd939257dfa3c9d0149247179b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "863a18066d4e134ba285b40e1593c0be6f1f2b1f25637934e939bf61e3e1f7ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "eefa0e2a88d2cb0fd90f137ebc3329914588a7b93fe35445e22dd5bdfb8bbdd2"
    sha256 cellar: :any_skip_relocation, ventura:       "cdc34a2fa4ab0e9b937097b199ebb6f2fcdaef88f97afd1aa12aec663d0aea66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "335b31124c4f34a236e7742b0fcef866ebdfa2289292d95e11740780261e71bc"
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