class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.178.0",
      revision: "a620e304958303e49ccf8aa71ef985aecbf63c93"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6107e4fe3b3d4d0ef8c4a15f677f028dd78f8e51670a608c7e0e81770d8acb39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd25094ff0a7e4b0636f2ef62801cbf5d4b583c2e3b83f5d55078e5300855564"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e00a0666d6e8f734aa516d26af8a52f51d3a8e1d299d4ffa1e33013e4e7ed55"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8ddc5f9e8d1a64f9b8fd01c6e0c3cd5a544222f59052561793ef3fed617092b"
    sha256 cellar: :any_skip_relocation, ventura:       "ac08432fe682a5e58fd4670c6a72acb87d0ba47b20d8e9be154429d75ca539a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7862fb0de1747cfc1321cc02561ab1a3248e0440f5d7aab2d9d5c80bdf4a299e"
  end

  depends_on "go" => :build

  def install
    cd ".sdk" do
      system "go", "mod", "download"
    end
    cd ".pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}binpulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local:"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    assert_match "invalid access token",
                 shell_output(bin"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end