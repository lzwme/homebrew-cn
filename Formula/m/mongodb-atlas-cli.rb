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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "107b9fa71e257ef6fb5444add7c9189db920f9bce4aa34b827cd2d28bc923bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6705005d7384093ad41c78784d070e231b7374b9d145d98e80a21e603757401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e8804b48d4233ede6443a266459fe259da6164d4f2cb1a039c1d45a94d64a33"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e5c208f2c61a0d0d51fda32320bea0054e1e2ac2262c9c756d345f8e6b5d304"
    sha256 cellar: :any_skip_relocation, ventura:        "5450bcbf237c1ebcf4c904650ce8ae6b34b5aed9e200f0d37481e836492362d4"
    sha256 cellar: :any_skip_relocation, monterey:       "68acbac6c7b92413afef39577e45441395e7d18a506d6e1bd4321633470eb341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fe5962e4b550dd5d0ca7db007a5caab0fa7775083f9417c4c1a14880874a223"
  end

  depends_on "go" => :build
  depends_on "mongosh"

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