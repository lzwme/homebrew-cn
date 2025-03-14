class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.41.0.tar.gz"
  sha256 "76326d2b7a4361994682458d14a982904f3c9f67f111e4415b52a1e58d5fcd8e"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ada4cc6df3dd6ae7873829bb36792c0535956926d742189742ed73b9dc8991ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71cb6ed87c1072b9e7af3dcc1e20633869d52633ea929ce399bd8c42ee2f2276"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1259003871278e89858d4c38c3696c343cff3c174ff7fd753a83138a85d3bbda"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d25f1b5083a8c85662d3cf88ab079a17bf1c8ea5c9263833ee116bcff87ee2"
    sha256 cellar: :any_skip_relocation, ventura:       "58a7f111f4ba0c3aaf3155b23e3500fe720719368dd364c1b82ec9f1b57e796e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2b7b3f230a2f27804894e937c670336485910372208a4cb4e1de8b7d979fed6"
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