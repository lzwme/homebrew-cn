class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.27.0.tar.gz"
  sha256 "fc76618cecf4a5099321d5efedb01f026810a145ef3f006c0e16e0bde0e54d08"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37db8dc8505de43b0c81a48fd89b7ecb7c1b26e4e1f65d4e84129704990df34d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d290323b3f98d8f571ee44b032f2301d8d4b9e7a7a4578eec09ca4f27c42ef13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f04082f22e78a49d01114424ed0b9394244ac400c8eada7201b08fdf8738e491"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a4f85f41d90a2eae9dbe12d3d3c75621b149347767207dea672d4bcde315acf"
    sha256 cellar: :any_skip_relocation, ventura:        "4fce565c3126f9f4533f1c1097a46584449eb47f35cd0333205c5f98712091ac"
    sha256 cellar: :any_skip_relocation, monterey:       "2ec185e9bd3a318bb62cf7749268c19dbaa7f27703246165693e1d9d99b8eaad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20005a54059d3ce2f2fd50f7102c6273600b32a1aa373122561e2df77d024fe3"
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