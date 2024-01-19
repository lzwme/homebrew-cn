class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.14.1.tar.gz"
  sha256 "486de93da0020440d3ed70257a1a4977a9a4a293eac47c9cf14fc4e81c998bb3"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ecbb47d3095f1d04fb2878f418e0281afe80e931162f9e5812368cc90ad3fb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71f05bfc9fefcd03128eeea85db4c419d79aef76637ec0686016c54426859fa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54051542aa3486e59d79bee26066f76332733020c387bada64d0df589ea8881"
    sha256 cellar: :any_skip_relocation, sonoma:         "647f463fde690baf8e59dcf5a0ee83ec153fb488e5974a610560043ff01330dc"
    sha256 cellar: :any_skip_relocation, ventura:        "26acd18d89a68f8d33556c7c0418df5cf9a58f3f032cadc6425053ddf3f0baf5"
    sha256 cellar: :any_skip_relocation, monterey:       "6bcc5eb96e2461bffe0b12591c2d5300e6d9e6fd471ca5e38cf459d8f2a8a919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe758768fcca960617a7d31702d3bb61ba7afc3aa5c7061b86fbc4ec04134a86"
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
    bin.install "binatlas"

    generate_completions_from_executable(bin"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}atlas config ls")
  end
end