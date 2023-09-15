class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.11.0.tar.gz"
  sha256 "85de0092f02e7af7140e47c27c38f1c8be386776d93165395bb0e2b09d2ffbeb"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f28eba2c6e82d1eeb9a64b8b99f0744e8052403a6a73a3e2ed6aa4bd78a14ce7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7db8ee18f9daa2bacec4bbb3a88767e4becda984d3589ff34494fb7e605da4db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "145b00c62367bf17221ea972fd11b4c5a09a5e7143f4c204e24c71c6afe47748"
    sha256 cellar: :any_skip_relocation, ventura:        "27342abfd4877563705e59f9b37e391995bb54e20f1b6bdea7fbf11a6e072331"
    sha256 cellar: :any_skip_relocation, monterey:       "35373e4b110b5f45557364afc93b424ceade5e0629df21ce3a1a5900dd9d76c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d6e5ee63067a9925f19df5fcbe9b971458d5d135f81bf22a8f4d3f564bb34ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecf4e4c32c89cea2422f3716866c1a748287caa765a53b75b706091ed27fcc5b"
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