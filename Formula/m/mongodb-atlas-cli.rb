class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.32.0.tar.gz"
  sha256 "ed17368b31d46740493c606e1a3b5f39f2ecb168aa429f2d7a2e774b31da9d3a"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f8d0b4d5aceca6950579dfe7a1492548650ca15d21405549c8d8d4bc52cb545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51be1bb191a341d056cc09177c3789b55084f971d80769ee63161e4cb7e810c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72c4a7b6c5fde8242559d6d6c525426346abb73a15c904401c95d8d209c310ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc9ed24303daa4389cad3783aa370a16ad0128d82a6292501bb8c7656ea44602"
    sha256 cellar: :any_skip_relocation, ventura:       "746d2d87913b770694958e5dcf4af8321af4bd338a59727d81e2e91e00d9359e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1442a967c97e874feaeb429219c2f08c10f5e5ee5c6d65328153fa42547d847"
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