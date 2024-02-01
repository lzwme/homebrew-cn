class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https:github.commongodbmongodb-atlas-cli"
  url "https:github.commongodbmongodb-atlas-cliarchiverefstagsmongocliv1.31.1.tar.gz"
  sha256 "e267b7805f59240b1e5aba12ea4df4d6cb2298f7495674b2028b922db027e90f"
  license "Apache-2.0"
  head "https:github.commongodbmongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "decb346d84912e9103424d28b2d538ae040daaf6130d893e344a07b7151a20b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bc02f317b826eabbc3fe70fa800a6073e4163f1ee89a0270e953fd51b07ddf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bedcc1cd4c5c7bef52cbdb369dcb5c0789fed31ef831065d722fa6cc1129ac28"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d51169b440e245cacd6451c37ffbf0dfbad917c0c36db1243b628e2b8b90a6"
    sha256 cellar: :any_skip_relocation, ventura:        "55be962e534461f234d50823875809729612a546325f9974eab8d368e0326e83"
    sha256 cellar: :any_skip_relocation, monterey:       "12382e1f9f5506c75cf3ed399e97660ad98537162f0da54c0af48f2e81b1cd46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e04573372440a7cf6b74cf336d359787c193c4864e2ef39b961280ca374591"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "binmongocli"

    generate_completions_from_executable(bin"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}mongocli config ls")
  end
end