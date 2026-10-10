class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/v1.59.1.tar.gz"
  sha256 "25019b03637ac003cd94c548d1f6b4c3f0446832ba849acf091b3f36f28368e6"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9808569fb12ff427153b03fcd62e40a3943d9a6908cfdfd23f5260abe618094"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9a9ebfa59743f865324fe6f69789a48f18f90325525856c2dc59838e1148df7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b4be6a7f9168bb7ec9109baa7b144d7f71fb8eafd474e40e9d9993a6bdce33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db9ce623b8d7cafb13bb4af03ee84597d667968536758b93fe6f45c143049441"
    sha256 cellar: :any,                 x86_64_linux:      "6814a71d86da09ab6d06e9e5a093113fa3246b09000e54913a0369b174b2eac2"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  # `test do` block expects an `unauthorized` error from cloud.mongodb.com
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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