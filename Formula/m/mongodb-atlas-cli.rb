class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.40.0.tar.gz"
  sha256 "435da70faaccd5cb177a59ed12964a260b1aa9689a7f825fea450c4c21c0743d"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c6b2624189d2fd1bc843846d283ee604bd4d6d6aaffc4e554cd0f907a41781b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "509636a2fea444ac54c9266ebd9ffba0735a41bbabefb68ed3df7c09efea1595"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1362d2f1c7ebbd0de7572ba4b0d5f23e4897ba38ca7d2afce1ad1e60186acb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef213cb43c4622eff0d54e7af4abdc9dc069d1d3d46502ca6cacd4a30b4c00fd"
    sha256 cellar: :any_skip_relocation, ventura:       "a010b2768c93fe84573c390f85d36535d4ca242327a77c05d07d246fb564a0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b016ceee101e5b6453b0f4cdb255b226e3e26fb3f32625018c30744f6f7114a"
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