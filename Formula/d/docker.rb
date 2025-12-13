class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.1.3",
      revision: "f52814d454173982e6692dd7e290a41b828d9cbc"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8be712aac62e05172ac6b2e59bb40150b5b4a4d53f6de2daf4e80e5cefa853f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f0054e96a3a9634d7175a998c5aeb882845914743ce822ebc1df014d57c3914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c5507ea7f51179b5bd76785ab4682835d2ac1d906252c7b07485d14237899b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "78ac234c1f93b6432f543ccdbc07c31474efc2f2e08c2761f875753c38724030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e32f5f92bfa72f60c22fa93135dbdd3993fffcb0cbf2bbe05ea28fe0a6a1117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35fe8f8ccf37abc1211c98847724445e7fd1c1943511494229b89a95e64cce8f"
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