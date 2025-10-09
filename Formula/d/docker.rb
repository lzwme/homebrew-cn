class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.5.1",
      revision: "e180ab8ab82d22b7895a3e6e110cf6dd5c45f1d7"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a032f9d8e396001b3ec86bc1d681c1105176f87e3bc5652dd3ad63308f0bca64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf1932a2232acb121535de2c22658cf4f690b05f8ff313efc56fa81f6113888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd8eea9cbcaaecec94ee1014c8c731a8af977c87d7d2f350939c5e26395c29f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "28c18f8ced0163a1bf22f19165647c3523de58db930d073b93e3b5594a703bd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f102d102fa13cdcb66e89747435138dff7a280b4f067e69ea72c22e082b3d771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2113d6f56025dfae0d93d2a79bf6d925174ea9d484183ca663a06c13b1dd74d9"
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