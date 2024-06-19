class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.11.8",
      revision: "95ab898c3cbcf298654d2074b478d35223e324ec"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bfe44534c757c686b53b441129d67b4c20c039fe64d2ff33b2aba27f724b9c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8f23fa3353f0aea5dede5d22a328bcd4fe61d80931a1ad1b0b49546d38bf237"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e069516990ac50ff26b8463bce05a6855da6323b6b330bd4711c8f3e3600269e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b39c5be40337ceebb8f87f6fb556efdcbd20d1b7c61d24fb8549960a3aaac3f"
    sha256 cellar: :any_skip_relocation, ventura:        "ecf2621e612db7262086b2117616db39001e8f8f402921ac7aefdff02392f5e2"
    sha256 cellar: :any_skip_relocation, monterey:       "9f6ba956f49184ff3914ee6bcd7a7f1c72338fbb36ee7226a3a6b291c9b63a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e7842e096c0ad8bd23e1dc273615e0d52a80e38017e76960b072b4a3a31a1d"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end