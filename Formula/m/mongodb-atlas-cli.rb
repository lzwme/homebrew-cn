class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghproxy.com/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.12.2.tar.gz"
  sha256 "ced54db686746231b84282e5244dc4459f4b2aa263a87f21fd689df3386130ba"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d88e696160cab3fa639bcafb6721452d1f9fcf6f940bc16deced8618ae0ccfa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad4c7c4ccff8f5846de428472b951e4035b0f899e1bb02e2a195858ccac7fa4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9d405115a9b7e8263cd39e4904cc6ab92bbe6d6d7aaca27ea1209e15d0fb65c"
    sha256 cellar: :any_skip_relocation, sonoma:         "671967585a12504e83ca2dede061d67919cf8b7d36b0409b6ddbcb2dec44f817"
    sha256 cellar: :any_skip_relocation, ventura:        "c9aac035a86866dbcc12d84bc37ee531f249ec47b27e40a34c0f1e40403fcb80"
    sha256 cellar: :any_skip_relocation, monterey:       "800fb7f78801f67f175bf3be656216015f333ef661ba3042d67c17fe512246e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0ac6b5172ab754a71d4e3b3175c3e564762ff54773a7f6c40c3f9f8ac154641"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

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