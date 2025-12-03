class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.1.2",
      revision: "890dcca8776eaeb472d7c9842f326d8c25805f3d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cdb49be9628d7d0335d204e9d707cee7cbfb67b7c7b84f726921696bc342e41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "254d1bd212fa43d2b237e186a02c1899ee498cdecd15a3b319dcab6bab67f699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5512a2d3264c679c3d934b9a090a8b840322db145681263b6ae2fb1d6683d5e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e96ff243dde9b9ebdff24e71ac9923c86aa5433b390513067006e6377b12b9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c99120d359ac277828cb4bddd62a3b5a7b03f1c4611176c11400c15e2c6c2e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf6817eaf3df2be27c9e60fae78d39dd5be7e1a185424fc0fccae2378e711630"
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