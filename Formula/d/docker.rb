class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.3.0",
      revision: "e85edf8556f9c8afdfcdce50c19f0b943efa1111"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a06bcd8bb70ca5f5d08af1e99adeebffa6c53b4f27ae05207f08420278c2f4ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a06bcd8bb70ca5f5d08af1e99adeebffa6c53b4f27ae05207f08420278c2f4ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a06bcd8bb70ca5f5d08af1e99adeebffa6c53b4f27ae05207f08420278c2f4ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd9e13bd4d71a932fbe0112949af14a41839110eb74b315ecca97df3b41673f6"
    sha256 cellar: :any_skip_relocation, ventura:       "dd9e13bd4d71a932fbe0112949af14a41839110eb74b315ecca97df3b41673f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b7266e6946e190e4b60b8ec58dd2a6170cd3afe0fd48408712403644861ec9"
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