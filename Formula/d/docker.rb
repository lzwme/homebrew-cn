class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.0.1",
      revision: "eedd9698e9c3ee3aa9100789ea4b4515443d2e50"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6734f3814f7b381ed8fe82868acb41f27bf19a84496e547db8e781cd784a8c54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6221edb6677806480a4ca7e189ddfd0bd0f38872326a125cf7fd881a3b35db6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8486f51cb69f92d7c4f7f6d2dfa02a167bfdec846cf376c403bbaaf298d8ac4"
    sha256 cellar: :any_skip_relocation, sonoma:        "241225bb969ef552e91f9c4abbbca5ffe4cd50a8dc66d517d65a68e7a766c05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a4c7c228bc518a6971c85d9ec9a478d4f341820e2d9b758581e2e6b464116b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10b23c073c30a5d621a6f654cbbb6f5e0e7f096d8888a7bc336b6c9128aaa514"
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