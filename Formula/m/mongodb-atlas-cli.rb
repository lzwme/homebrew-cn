class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.39.0.tar.gz"
  sha256 "970b7160cbd261013018b8309dd55eaac64a8c54e805f6dccc643b52c2a40bbd"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829e2fa7605672125dd3e88fcf87df664c2aa24ef1a0f15352ff0045b08c0153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8628da6c8f6262358fc109797d0f45c80a8a7b36879cb2e3546ba62e13ff3f08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4927c13372e5ada9a802086b5fed7801f006ca1aeec313510ebe411f54076862"
    sha256 cellar: :any_skip_relocation, sonoma:        "83b113b09998cc5152df2b33c1341a552199ef19296eeca451ee01c798bb2532"
    sha256 cellar: :any_skip_relocation, ventura:       "71914b95dfd7de3fc29d7aafa537f06136b742e85f72a49bbcb32fa69560192d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e475409f4835029f025a87e933b92ffe2b63fa1785e4458da30253ab4a78732"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "binatlas"

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}atlas config ls")
  end
end