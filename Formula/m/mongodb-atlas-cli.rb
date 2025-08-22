class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.46.3.tar.gz"
  sha256 "da136f07614fe360e496019ae999b054dbb6954294d4239197cb638dcb52e97b"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e743f534fbde63efc1c3426299e861841cb5f3895ef7ac31211743c583a584f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf9021c9bb113a8a856fcb26c58d992b6007e31bf3393490c1363872f36893f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a231e502998a83c3c0977b599e5b7f098901ebf621fd41786bc19e5391542c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a8520b26fac2767dbad548655f5886fb3cf6f1bec1a0f1c25224af0171ba2f3"
    sha256 cellar: :any_skip_relocation, ventura:       "de70c578365c7a2f61573b054cac81eec57e1d2febd9fdcd4232afd186e9ede2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6dff98b7c338a8bc0fa6f8f6a96c22892577d315ea224d711e988442554cd8"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end