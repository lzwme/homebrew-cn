class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://ghfast.top/https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.46.4.tar.gz"
  sha256 "d3ddd1a1f3dc603cb2516215517c56278ea88557bed954fbb6ea3d51a1dd00e5"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a29bff58b2ee1a88faa8414893f7948f683d41371072d9b1993d66aea45ab12f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0be3dfc18ea74c3d2880385d44b18deaeae48407ffbf78781f6839362d79d211"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1264be91dc6dd320fb4aa87ec4dcf04916f7c7d5b168bb3abecfad16c8482275"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c3b7b34e35f11c19991f15f74225eda351999c7d0c24edfdb988288928b562"
    sha256 cellar: :any_skip_relocation, ventura:       "0ad8bb9a23de717311fc64b6ffa887a9365218738b48f4e13cec8ae9bf3d40f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a422b30dbf6665cb3cb20321b2dc7a1d7e748f095c0ba475f93421dfbc6ce10"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end