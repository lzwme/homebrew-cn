class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.38.0.tar.gz"
  sha256 "cb36e014ecceefd59572d61cac951659b0cda95b1dcc6be67b1fe37c1ebb74d6"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf0ceefc25dd114a050f60a92af73f5937683eaf5718bc937c9cc04d3acafdbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d22a90ff17f4adeb2e5867eac77f5820d55c75123748fe421dc9cf4f9900209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "177f52a570db665892435d672428aa4174f52fb2bfc45533ed0cfdd694768c79"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb3dbf31021ce3f67e42814f3ae15badfe515c50aa8c2923f210e19bb6d4da0d"
    sha256 cellar: :any_skip_relocation, ventura:       "258ca6318408f40966807bc0e51ff40b81248712f2cef79c482d05aab314fb95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c00416795cef2a6accd31937a17f0147bf563b6f0b71f21ede1238d9ab5be0c"
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