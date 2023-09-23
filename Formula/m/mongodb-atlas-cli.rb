class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.12.0.tar.gz"
  sha256 "9c070a8b3fdc073553480e9c75d531f3e3150bc626c5bda15982617f776b8867"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8adb611ac09f5f493d5c513141b8453b11596e942fe9ff41fb6598efd6a4b662"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd5dfd3af9278143b5854ccfcef2bdbc56870058654803dff7aaf212d54d86d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b00234242e8ebc888397c56bd0f2bea5b8e6af5cd4f43491b2f31c4c6c09e53"
    sha256 cellar: :any_skip_relocation, ventura:        "734de9647bcbab303a038790f53ea3d197ca2e4e2a942a140c9b932d87c096e8"
    sha256 cellar: :any_skip_relocation, monterey:       "34cc32e4e9bc15ef9543e31a0c8d11a0459aa0d421da491c9c0ce54793c69f50"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd1d8e0efac0aaeaebcdb102446fbe6e8156c4d0921d8f8c7079caebf3f95d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba3fe8fa519b09a49271f723bff5b68e5e4470c890d1c6ffe4fb9c32ed7aa06f"
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