class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.1.0",
      revision: "360952c8d3f77a717af8aebba62b2dea81c7c259"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09ca5275dfa5e4635c16e1dcbbad56517a3e81b23f58b5042052519a412e718d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec442c480a33fb88a63a6771d610c8861bb9f537c6e6bf20aeadc3ababae3088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba967a0e1c83e94fe1e953f68f5f8d339ba5dcc114b7a1f77098743bddd2f9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9deecc9ca277f591e176b3228a7b700089ef9d7b020933a662f4eb2032d695c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7b8c4928dc39ba7b617356f64be9be710507bc2e5b7e62793365da9ba4514a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd71fa3a6256b85b781bf306fed722192771c6c14e0715afa24b0b3a991c572"
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