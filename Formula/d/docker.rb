class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.5.2",
      revision: "ecc694264de6b34e4b59d16245603382f22fa813"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31dc3d12f9bbfc90a9f3909023a6b5aa8d69dde01347d5d468199b5ddff7cadb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c7c33f91519f6d461f2b42c009cc6b70c01828ad705cf2a77ec262e0021b98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed88aaa6c16dae74e8eea1c393911424766d8f1c42d12912e7bc058cd7d670f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f99c461aaa3ed33490692094d9739857eeba18cc9773a8b32563250bbdf6cdfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7734964d01a34c4a57bfc7795eea0094c8dca0efa179aa04aed85a5df2e08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf5857518ef1a2d5511247374c92cc221404dce7c15eb9da48ee6ec991901e7"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}
      -X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}
      -X github.com/docker/cli/cli/version.Version=#{version}
      -X "github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end