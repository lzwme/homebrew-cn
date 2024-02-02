class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.9.8",
      revision: "0f6c20d825d1195f2f54220d959034f0934e354a"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8be5baec44886c7e92e63a569fd4c1b5c86a0f66b059f44734cf0883fb0addfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e61a15b7352eac4886e172be82f5169bd02d6f430024fbd639dc749071ef497c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f40ec79dc9edaec1dcdf186fba41c397146315b5fc55dc679e6bb7dbd323ed90"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ff54fba71954738f4f3e8f484d1752659a362bfd98c8c30e5fcc1e7848f4e51"
    sha256 cellar: :any_skip_relocation, ventura:        "7cdf069d1786070c9b3285487491415c08249342a30a36685a6c48a3a2e0e84c"
    sha256 cellar: :any_skip_relocation, monterey:       "118f8998baf4eb3188976f06cdd54efb8676596575dbca34ff335e755c01c1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "330789cf6c68397b91ae484c341a87531d459e08b441ca43cb90249092ddf076"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end