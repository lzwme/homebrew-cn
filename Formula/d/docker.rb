class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.5.1",
      revision: "9f9e4058019a37304dc6572ffcbb409d529b59d8"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c83347930e258f0e330059da5d9fb7ce03b0842e45677280b00814c5c38a53f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c83347930e258f0e330059da5d9fb7ce03b0842e45677280b00814c5c38a53f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c83347930e258f0e330059da5d9fb7ce03b0842e45677280b00814c5c38a53f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "937b1fd00bdd873b21a92a9749ae2c804364a5c2f93ef55a6b4b993063d7fbcd"
    sha256 cellar: :any_skip_relocation, ventura:       "937b1fd00bdd873b21a92a9749ae2c804364a5c2f93ef55a6b4b993063d7fbcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23acc432f5ddb092e2181fcd6419abd81a1c39cdfd1d80a4cda555fc436a3123"
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