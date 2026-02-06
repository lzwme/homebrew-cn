class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.52.0.tar.gz"
  sha256 "51ac338e88d818ef534202f68c33f74c566701b5b26caff1366918ec8a653998"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3794c1485fc42a21fc805dfe398d6d3d1b29b57151b1b046e6cf21e2afb901a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f82e720f11ef50bb57908d7c2e76e09d3e4898c97b32958ab9f06ccf0af6c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da698c7c80a6b896ff2c637845945009881f2bc20795ff625d90503c7102ac1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3900b417e8da15aeecc9bf199a43bca1745edb50d825088e2e76f5c02ba1a2e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd1be02097762b2c65a35d566c4a4e0c9183fd8d218ec732597d3c7064c800ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c9233cf8ea6615e14a735fe582a6ba8d9131c4aff539704dcbc3e281b55c24"
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