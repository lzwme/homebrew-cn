class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.28.0.tar.gz"
  sha256 "949a12053c4e6159130a6fb7620b4c9695356daf10cbe4e23bf19e9d4d298639"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8017445482840803c9cc5081c185008d0a044475134a7a8a9a8c1ecc4efa3cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc19635f7be41c8205aaae3b75890244cbda373b73cbe06cb88f2e3d6b04d48b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0d8d29baa8fd9f8945ab2759d858c2abe456e64354562d30b8962850347ff87"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aa107cee1e81e7d0c0042668fe2220969f88ef19a1793661dd2d306c29353eb"
    sha256 cellar: :any_skip_relocation, ventura:       "f5264d2f63b6783de05fe6ec5919a57562eef5d4d43b7aa9680cb2b511c03d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f23cf99b1e3c8bb4239c17257e3e1d45ef0f972ca60447d7d9ef7332239035e"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "binatlas"

    generate_completions_from_executable(bin"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}atlas config ls")
  end
end