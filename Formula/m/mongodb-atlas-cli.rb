class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.53.3.tar.gz"
  sha256 "861d36678471e1c705e12639e10064dbf202f86e7946ee22fdec7ce96cc00fbe"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2f94ab4bba2af1f139f40bc4fa3a43d67839a2ac5cfc2f05f7c84fbdd76e9a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a7b89be1f00b44681e8f1ef20228f94df9b94453cb36eea49a784ebc67b108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3a0fa7f8bef6ee3d06e4ac7fc4eadc6fdfae7741ac20d20f641a50899b68d37"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1fabfad4bc3f96eb9409d952816b227888adbac006180254b052f478f8c19c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d9928e86193e2470bd3078cbe002267f229ae870eb7d57f89751afe641c5ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d152055518ab42429f17c35430a59ead890bb5411a3fb18e8ae0c14f25c003ff"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end