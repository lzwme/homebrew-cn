class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v26.0.2",
      revision: "3c863ff8d3f0b81f25ed3afb60f2822019c4b94f"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "903ee1d20fb6e134883459d1ec5c66f7fac12e4a9927fb4b0711fa93a849c19f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c0df5e35eb281d5f567ba5d2d8919512bdcfbf3777bf69dadb7f20cde158455"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69be1371fef895bfce882e905a2149ab7ee54a59dbe3d221cedf39cd19535208"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c84a7702afacfd9a332c3e1495d91c4d43a3fda41580688c2e3a0c5c671bd1a"
    sha256 cellar: :any_skip_relocation, ventura:        "ac8a85e8062d14e35f65d73ba62a5541236d446f44d773ed842b4e415e637240"
    sha256 cellar: :any_skip_relocation, monterey:       "cdd28fdad53d2b164dd395be0369d08efd4d993d54789103c243d76e9d5ba8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "762935a56c6746b7b6450d559ba23834062ba43c6c781c16970bad2af175a8bc"
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