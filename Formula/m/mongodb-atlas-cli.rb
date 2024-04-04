class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.19.0.tar.gz"
  sha256 "16afce553bfe44e756e3bc1463a833c9fe9f441bc2b9f03d092fff3745184d13"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df746b8804b8e819d79707a60044751affb02021d4d86a48ec2461d1113f6b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37839f3b6221db1129de032996c2c26ccf8908592af16b2300bc6ce992755270"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f38810d8fd6eca848570b8e767dbab3946e91e03caff826faf04c097cdc09ec"
    sha256 cellar: :any_skip_relocation, ventura:       "1928b8d2a8b21314923e2e88a31a75c132ae0736971de9e0f68a1514411cb4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1778a07336fd6f00e19f00ff8f6286063800fc140f1b4c8981113b8c42aaf4"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

  conflicts_with "nim", because: "both install `atlas` executable"

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