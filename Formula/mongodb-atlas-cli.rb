class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.9.0.tar.gz"
  sha256 "130819cb4849511c21dec009b7ffaf9a6a18f4858104f12f9063dc3cf0ad07fe"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0f3a03ed6580de4e845b45308e0a8ebd4bb19611a2607f78c42ff57dd2f74a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ed79b80ecf19a1a565bf8b9f68c94ff80c5cc64097b06b9deeca4c9ae0f3fef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "473bbd705ff59ef4c761d6489d25982c7de889d5975b5137f01cbcc952cb9667"
    sha256 cellar: :any_skip_relocation, ventura:        "63b48b0e1396875c8e9d2731968b5d1ded5613b1ae23204ce68a6d4bc048b883"
    sha256 cellar: :any_skip_relocation, monterey:       "281a25149ae2a05a759b5ef6d4abe9d5042c939e1d7a25ae3c11d2001c5e1a86"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e4a5fe26dde1006ad953a13b8197f88a325ea192a6f9db691487ea13dd3348a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c879508c605c0874f54d463d30c50fb3cfbe6eac0b6f06d476583d10b3d408c"
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