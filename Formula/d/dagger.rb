class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.9.6",
      revision: "44220f911b8ed4319478cb5122663d58dbd5e61e"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f29632c30a231a885d7f937be0b96547f06b7279d832a144d56a7d99ba62c669"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2d16d19a40daf3bef48cb977b0d3cc9f8d4034c8f0da893ab5d32dfd8f52ab9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "603e21aa4aa349d74f56377291b744c02f856d64ed32e3dd9dad699636effe63"
    sha256 cellar: :any_skip_relocation, sonoma:         "39672df5130e455283391b20c26402f7dee941c0107aca49da418776b8d33fd9"
    sha256 cellar: :any_skip_relocation, ventura:        "4bbf16ac3fbcac2e64bfbc128c31dad88bc49c50653db6a4b38debf93dd6d5d2"
    sha256 cellar: :any_skip_relocation, monterey:       "ed1f7e9b4e7193c576224ff23ad6f418993b36b42c8f290ca14bd2f679765987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "812d3d5d5203877393e9126dafe9ad6744ab0471590446aa0e3dbdb948e7a786"
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