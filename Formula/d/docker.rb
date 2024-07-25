class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.1.1",
      revision: "63125853e3a21c84f3f59eac6a0943e2a4008cf6"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e5b8b0c48e90a1cf2228350cf48d6f142754b87078cb426a0c4e20a6774288e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6f6f1f5ccf8caceb2920198a11cab3138b88d66d451360920c693b36eb2731c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "410819f847a8a9833511c57209b60c13f0b9292af10265d3e2422710d86c5571"
    sha256 cellar: :any_skip_relocation, sonoma:         "21b2835845c49bb60a82f1e037f932b9b7bf1ed1df7099f22b41f4829a9667d1"
    sha256 cellar: :any_skip_relocation, ventura:        "a349e35bfe05c48630328234afb8890a2cb549722663a60a78940dddf2848ad3"
    sha256 cellar: :any_skip_relocation, monterey:       "e31032c85eb2589f3c0b05b91f2f42089f2825a8864a4fa71c4be0252d34f325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36cc40a7cccf6884bc3f9e805346202bb11dbc9be135d6b9667fd242029ec73d"
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