class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.0.2",
      revision: "912c1ddf8a3eb97595c5ea967d01c0fc18666409"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0ec54d1e1a88f472c34c4faa5d6a698aef5f66f2765bad235b51eac782e9d48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "607a1b269a5004ccd721284c8f2ba73bc3d4f404c3cbd3a475369bdacecb94c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23f7075fc2d1303bc2663297adebf199fd6ad18a18829efcbe910ddfa28eab56"
    sha256 cellar: :any_skip_relocation, sonoma:         "62b6742be40731b9501e200389f17c503981013b6ca81a7a2b9644a8c57ca136"
    sha256 cellar: :any_skip_relocation, ventura:        "7450e6fac178a43998801a81a5b040eb8d3d61ef1d1e402595466485d6ba6f84"
    sha256 cellar: :any_skip_relocation, monterey:       "99fea5c3aa47168e8879a851e443ff1cc78c03417c64718e4a383f99aa06033e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d031dab316895d7c26eb72bb121c68c2e64d94765d42d0b5a727b287d6ada000"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  def install
    # TODO: Drop GOPATH when mergedreleased: https:github.comdockerclipull4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath"srcgithub.comdocker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.comdockerclicliversion.BuildTime=#{time.iso8601}
      -X github.comdockerclicliversion.GitCommit=#{Utils.git_short_head}
      -X github.comdockerclicliversion.Version=#{version}
      -X "github.comdockerclicliversion.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.comdockerclicmddocker"

    Pathname.glob("man*.[1-8].md") do |md|
      section = md.to_s[\.(\d+)\.md\Z, 1]
      (man"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}man#{section}#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}docker info", 1)
  end
end