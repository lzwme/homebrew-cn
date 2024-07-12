class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.25.0.tar.gz"
  sha256 "ab9378bf2ee276c30b9221c4fd4e7b1c95358abdb7f27c6b9743ac2406619f18"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2268b939259333bffb06cd76963091aa4e7d4640587ca2b7b7cb40fce768308a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fe6d8e224b94fe18f729b71f1276053b7c33cbe5871580ef6f2e252bd70adc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "314f103a1a341e67f9910fd6e0903996084f479c6147678be64608e03ab65c80"
    sha256 cellar: :any_skip_relocation, ventura:       "5652801cf8785128f10763235b13f9bda72def3825a6b05f229ffd9c321b862e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ac364b3933960fae5d35a57cb897effd51a8ce9f658f6b7ee7a7da8ee15028c"
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