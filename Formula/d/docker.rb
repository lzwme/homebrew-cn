class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.9.1",
      revision: "dfc520dcc28994c4c699b9b219fd2f5a6bcec0ff"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb04b400ba25f113c10ff1c3c9febc86e1b01f70d30640b50383978bb71182b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa2a87d71d8d14c8d38bbd3c94f8f41da96a61401e9f32c87c6228064d10bce8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afce07c3bd62b36e1821003e8cd2ece3dc92325be491a85292ac381d2d71c25f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50d01b951779a88b39c880620d66b2cc8cea46594d3793d620e1a5302a19e8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ca0f8572e3ad4d81e2b3e01b25ecf462655ddb00a62f4c81dc7f3b9979a519ec"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
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

    generate_completions_from_executable(bin/"docker", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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