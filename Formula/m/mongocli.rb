class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-cli/archive/refs/tags/mongocli/v2.0.6.tar.gz"
  sha256 "f345dfa561e71eea9759ddf29ad5961c57d63f4b43c7535ba8a99ee48b849338"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "082900e821946103a3ddb01297607a5cdd5241a57f42c5b4cacc41c22d3afb45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901eb552a683ca0e6b3d4fa461f2c1a857b96330586471894e109b4f63594051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2915e3ecdd85f04323e65439f8c6b6d358a5c8852a50ec093b40d0c07bbe0cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e85ff36e64fe3d33863301fcfba371808bb09a00773d052b6b29f5e301ddfb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627a29e8ef66496df33344b3763ec2c537c693cfd0ae31bc16e5a33487f7a789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34dd1ac20a70c44b2cb35ce0bcd2801dc7a7e103810a5075e183d63312efe38"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", shell_parameter_format: :cobra)
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end