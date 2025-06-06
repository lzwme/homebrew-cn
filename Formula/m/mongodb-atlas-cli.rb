class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.43.1.tar.gz"
  sha256 "3458652c5b5f4b5cac678537819e3ab4e9bb18414c37e27a494c8591bea9b4ff"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54610de80e278a9d3b37533e43a078e19dab002c077ee7cdcd6cd9aa0da01859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de56695d7eb61a43b7364b916c46730100318c8efc8e64b63778d21fe4b1731b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b5f649898b617104dc37a079ba25553aeac02b32b5e7904961e1d7dd1382b64"
    sha256 cellar: :any_skip_relocation, sonoma:        "156771314390a404588bdbacd811e2a0509e65a8f0040fe5a0219725447c9283"
    sha256 cellar: :any_skip_relocation, ventura:       "e72e8bf4f4713a3129c4cf7d9b7ab732d09de18cf906bd588c2083831b3e2f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19aaa68e62bed08aa3cd26ba5352159ed137aa8f9908cc99654189a3918fa557"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  # purego build patch, upstream pr ref, https:github.commongodbmongodb-atlas-clipull3925
  patch do
    url "https:github.commongodbmongodb-atlas-clicommit5537ad011ddc25b6cbe7fd7cab10bf20d0277316.patch?full_index=1"
    sha256 "8201cb67f844c7c52478e82590ac150a926f3d09bf5480949fb53e8db6a1d96c"
  end

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