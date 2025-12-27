class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.51.0.tar.gz"
  sha256 "d1ae13a071f9d4959819e486014086580478d796a487264ebc57010470c51cdb"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "735cdd2fe27a7163388dadcd93706101c1be71b55ea8fcb3dd7bcdcf1d6aee34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b19a22a4c35e33a6331d5bf1a3e09f913eda6c9e61f2d07526066ac92ca0ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b354a8367d0326b17d1ad1956196fefd43edeae5a93ed385772ec18d285bea7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "49aaac74499879d9ce08d319a90847f476d3e1aaa6c5e9975e726509f2d7b618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9d272b29076a168a95ae1bd304c5ab2301603970589361811a8c6f07e90198c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b141c66b24be87cdd95202aa9e7331024c7293e031af9f7fadde939c9f8e501b"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end