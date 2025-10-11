class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.49.0.tar.gz"
  sha256 "14d817a862d38b841154c8c18c20c20f1617de97f2a3434ba85bda34cb624511"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "648c67058364e759bf6281cbe7366f82ed5005995bcdd0861ce77675179923c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "440cc75336c22ca4db13aa3014e0af446f6b29639cb6c7c8e53b3b9551f99760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4541a38be7c265c58062b7988b0c6352d61a689bce63ea5ff97b53196c382780"
    sha256 cellar: :any_skip_relocation, sonoma:        "506bd3343b409e2e196cef7a483ecab7e2ebf0f786ec5817e1202aef9d0d9a35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9df264d77dd8af150e1af3f6c4c439167320d0e1b14969fc37fd8a0c5317631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa2eb722ceebb073731c10627660a7543bd00533dd962ebc145dd8ba69563a8"
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
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end