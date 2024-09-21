class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.13.3",
      revision: "d3a02170c96d4d81343dbbcd5c555ba6b8d38b45"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62070338028475322371c8a9c5387988486896654b8ab57db9b25d7a7cddbef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62070338028475322371c8a9c5387988486896654b8ab57db9b25d7a7cddbef0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62070338028475322371c8a9c5387988486896654b8ab57db9b25d7a7cddbef0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e175d339bf97c33fb8090bb86d0557691328a21d6cfc43b555b0931dea5c37e"
    sha256 cellar: :any_skip_relocation, ventura:       "8e175d339bf97c33fb8090bb86d0557691328a21d6cfc43b555b0931dea5c37e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1e0e9b2163ee9311ac077fccc98215075723301aa8114e0da370b06ccb14d0"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
      -X github.comdaggerdaggerengine.Tag=v#{version}
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