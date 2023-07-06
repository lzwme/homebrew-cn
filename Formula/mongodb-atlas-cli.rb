class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.9.1.tar.gz"
  sha256 "0d4d0438136f7d35e6ccc7a4d12ea4e54c98287d0b33a231d29a5484ce257916"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b7293058291787a1514852f9be59862eb09d2d2e82ad5b289c2a99c0aaea1a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3148f080ccc9b15cc561817ad7e8457e08f47e9e0c9c7394ffbb90056fb10458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c744051af470721e8d3491fd64795c8d9262fd006fb3d2b398a297fddadb6356"
    sha256 cellar: :any_skip_relocation, ventura:        "31599c99a37f77187beafbfa34b9ae237e1bb8bb916fedff676e147cb91c10c0"
    sha256 cellar: :any_skip_relocation, monterey:       "3ebbe2a31f06153699612fc6ce40d873163fab7e10e5a5c9f91e4807ab603d51"
    sha256 cellar: :any_skip_relocation, big_sur:        "c410a10a0bf2da38f4670ff6f4d20cc0be879b46bd5f02357f9be2e155ffa58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc35f3efeb9ee3ab6faf32ce920fe899323ffe530f66dee60d7a4a8d4dddaca0"
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