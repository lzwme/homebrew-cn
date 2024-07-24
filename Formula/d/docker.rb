class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.1.0",
      revision: "63125853e3a21c84f3f59eac6a0943e2a4008cf6"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a65e4db1f2977a8b4838fdbb002b78f7ab2a2c8e6009e0c17ab0c32d191a43d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf9e5ee0f7ea74bf90b4731c8cbc6f0a59f5ed74ffcffad0cd8bf40c4b5e2c67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "151a0b1c42381f864d99c954cc52d96a94bf259dc8bb7dbfd4b903e3665198ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "519a4975d1a5345f7ce5a2b1d1c4c549b639c1a9f627f376959cae6652c3d987"
    sha256 cellar: :any_skip_relocation, ventura:        "bee88792192dec31f018f79df87cc2a008f40a7a5a521e0206650a43c05a77c5"
    sha256 cellar: :any_skip_relocation, monterey:       "4eba5a0780f1cd9fe214871e0484fb87eb46b37dc11d0ec9c79bb31fc484e6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91a534ab7b1c5158eb5b58bd3bb76997a0fd0a0a8581dcf4ed893474adcc620c"
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