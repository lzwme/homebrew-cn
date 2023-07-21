class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.9.2.tar.gz"
  sha256 "5395259c7093dee1b3854dce3f0c8903ca06394fb5464216072aeddf67f0f613"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ccad9dc2d09194c18188de23ce13c3f42525ca8fe8b06f751094ea4ac27f01c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab642f2fa4271969314a65c5bd1467798534f0f80f4758f786ddba4c5c29a434"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06abf8d43f9e8e3cb937e3475ec293b53a2c2584722e29881514e05c9fdecae4"
    sha256 cellar: :any_skip_relocation, ventura:        "2ba7ae0dd53d86ea755a05bd3b516d96e37b39582abb42442164b84081874fea"
    sha256 cellar: :any_skip_relocation, monterey:       "6c36b0ede94dbdcee12db88adfbe7d69c040edb7b58963c6ce8a681000216b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "f62b3c51470b30192edabd5084c173a3ecbf3e30089784c2beff6dab796e5469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d656a1e2dd6741a8cbcac91d91db4f649968f13413d3f3a9b5dddfe5a4a0579"
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