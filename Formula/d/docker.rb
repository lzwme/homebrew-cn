class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v26.1.3",
      revision: "b72abbb6f0351eb22e5c7bdbba9112fef6b41429"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "730ae81ee6d14b6c440dd9cf4022766dcfea188ec435c65a511c352299f1791e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0559160af909fe293e83b4720cd11decc241d4f37ce738c5e84e6f0a53165eae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95349fb3a717742df4fa880062bf1aa77389b907c6b52d6294702e5168f6f5f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb9f053bf2e867e09e8a1305a918036f882bc6ba4460f5857eb953a1852c3bb5"
    sha256 cellar: :any_skip_relocation, ventura:        "801ace3d3f34c31e6c214f73cf6727dce1612e0c095c18d6e99ee14850edc26e"
    sha256 cellar: :any_skip_relocation, monterey:       "2a82d8fb6cce10d3935bd77bfb87032557fb7fb36c5b456e44145e4e604fcd86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9577020605d781755d44e1e9a125b730f5613a2012eedc7c961bcd94eb14efc0"
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