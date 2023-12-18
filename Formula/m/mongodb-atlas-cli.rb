class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.14.0.tar.gz"
  sha256 "385c9a4a86527643ff5fd73b9b59ea4d8c95dedcd00f7726e82454f4a90253ba"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdfb7ed5fe9c522b6b2118e4eb4d1d45b571a44305765bec112fd2fd82721adf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4955b4977659d4812bf27c951a0eb128cf7537b546e7eb819786925c2e22f499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb3a50f9abb7fec87ca6d8edb19389b77058babc59e005a7114ff86a0bde5a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "00c4a0921be1233fdaa606607e4b201a5bb85e3399384f7204e0b944a6444902"
    sha256 cellar: :any_skip_relocation, ventura:        "bc60a311d05d0e3f68ae77734e969d6f6bd2ddbb3748c29a9b6de4069254c74d"
    sha256 cellar: :any_skip_relocation, monterey:       "4a74f3f0b82cb07e95d5c4a8696a10d34caa9f6fb0fc7976994317f5e4e892f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7825972f4f4c55695c1d4280676ab6e4bd456e68eb20fe333075069982a715ab"
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