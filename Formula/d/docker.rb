class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.5.1",
      revision: "2518b52d948a0cbee071d394c03c86a3005636ba"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f8fd78dc7d382913acf7cbf4ab601513e62bce74a933143072bf83794dddf66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93e1097a8cb2a344a2a9c41d0a37faab50a1af78aad9e5354ae0fc1fc77a71b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e8fc1c1e65d575357068ce6134b63690783d04f70818252a6cfd9f150be1906"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cdbfb6f784ce9313e72fe3ed5a03b7e349a15a2fec5df0ba91c1cf0e5d783e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157f76acc8ce99b2c0b2a1be8befe7c31c555ca4b8f5c22ede0a2f86cac34a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2caa65c4972c28e43c6fc0d25ec1e1a03726969d3d6dcd31e2cbbcd0553f57d6"
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

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install docker-engine
      EOS
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end