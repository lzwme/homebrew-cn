class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.50.0.tar.gz"
  sha256 "1680d74e7123ac407d2fd2d7beef606943daba60dc9d63a45cbead704e9d40dd"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e1100dcccaa84ed1a6b7fafd8b3b92b8ef774b47adfa12fe47939cd2a77dc88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d8eb6175cc0d9634820456d07bafafdfd70fffe0bc5de5867e790db621c4300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bcd074e86741d66a0e9c26bff81f939a06fb1dab5d9019b89c94fb6ecc901c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6a0fc2331ce08d155d51c1e8526c27fc5890e6d3c2cae4044ed808ac8de5641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bc5b0f423f22526afc3a84e928b8d054ed83c63cb67f4bb4533d30af1f165b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af00d7cea46a6f4b13509e6ced1e689633696feea921510b256796771388f0e2"
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