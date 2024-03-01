class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https:www.mongodb.comdocsatlasclistable"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsatlascliv1.15.1.tar.gz"
  sha256 "ced26bbf859750e11002c400af6028c19c4c949f4b3919cdabaf2b07a39a5489"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad297d602c84629f6b44486b0f4a4ea2b5d6f5481ed6ad801ba659d6a323bcac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57f0dbe449685e822b6df994f371d854acd17a4b06c134f8ac02a54d00252ab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06fcb468a0386414cf980df895eda017ed3027926e5ad3c2aea1d018e1587bb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "426840bcbe404170592aa98fa1364187e938102a7dcc63bf18c0007be147f7ec"
    sha256 cellar: :any_skip_relocation, ventura:        "da085ebca3660c7d0d5f6fddb4726b96664ceb40a41a32d572989236c8e15a3e"
    sha256 cellar: :any_skip_relocation, monterey:       "7e96991cd3094098eab04c21d66d71e7a36e77196fdc999561bd73593ff5dc41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f15a0b00a4076ceb97b96deb1c88f34b2674172a40f91f10b1baac95f2eadd"
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