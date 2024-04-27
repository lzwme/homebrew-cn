class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.21.0.tar.gz"
  sha256 "0a89a4de41839ea7bbd8416edbd4630176ff8ebd9fbc4084c384cf214c9d3ac2"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f10b12487c945972ea18514fb3025948f1de1e146799a2257ebf4de709dba4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4627bf0cfe81253ae7a6c3acc526b7407870fba68a3b7b0f656ffbfb872ae617"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c679d94a29440260ab96916d33711a991746342413db342776db8b838505231"
    sha256 cellar: :any_skip_relocation, ventura:       "cb1ce28f7dee521f560930bed6400c0e7b4949b8055fe802468238faf53288fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fefe255d9044f004ef9690e3f12e419d60cdcc974bddaeb8408643e43c10735d"
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