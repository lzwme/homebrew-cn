class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.7.4.tar.gz"
  sha256 "b9cad2958b0895ee0da181026e9d55cd9d50e70124002d1b4dc5b7f7bac8491f"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f6341a8fd2716f74a7b88ddd900b36f757ec8377ab45a387dfd7aa2237905a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20edb943087f20d6c3e55c51a7a018d77860c877127a43bc893761daec6f8418"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7eeff9e49ae589e97bd25c289c3778f66bf21f4d5ddca77bece7ec2cbd4fbee9"
    sha256 cellar: :any_skip_relocation, ventura:        "462cb3e7f21bcbe9be6dea164be7effb737d822c8f45f639a9199164818c3615"
    sha256 cellar: :any_skip_relocation, monterey:       "9ba47a3f7924c590173573df72ea0b010bd264aeb1b0e0e56844a05b730257fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b30cf545c82b4fcddfe6b75ddc0130a4ef3d160dab61408576073c1ee03238c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc54fd030b9fb8bf884b1085d55b64777573ee0ae7b188714c718c36a2751044"
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