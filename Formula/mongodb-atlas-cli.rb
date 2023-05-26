class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.7.0.tar.gz"
  sha256 "7fa467da4def732cc34c6eff14ad8d59ec59f559145c4e65e32890296fe9d063"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a39e8a8e3247565aeec534be76e14a580a9a6aeba88a34b2e5bad19fd96b1de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1bcdf7c01cac9b08eca50c494d7d58dae730b5c56edf7a140c6b8cedd066b3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4490f4fe6625439caa01ae9852b51f9c8855fc8a07502ce1f6d8a3342d5ef3fd"
    sha256 cellar: :any_skip_relocation, ventura:        "17818d2908c5b0df8c7c383fe8c50520b8c1092174b88660201ed692bdd7e7b9"
    sha256 cellar: :any_skip_relocation, monterey:       "672b6ebc00deb426d28fb2ffe13e526d2f647ac6792586d98393478123e218ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "5de5450011e6a41bf3bcd3b30f1c0ec41064f78d7f497232738486a72d80c3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e9db7fb1ed8413ac357b1282b10c052257d1520d4f3d03832a7e66f80bf41f8"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end