class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v25.0.1",
      revision: "29cf62922279a56e122dc132eb84fe98f61d5950"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c211945489f9d3236fea567dac9d940b7162375684273f0b30e8de74b34a3fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a21b011909ae52b125fb8e0493ce10fc9f20508b1762070e26038722854dfd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aab8ed2711f084b55c4d90e8b602f890b8563ec73a52d9d485375e1c229365f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5225d8a64cb29703d10395d887c479fbc324be70ee30da5974538c00d27a0a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "cf513db0624b32d0033a5c9549a5d65a2ce07c1c454826fe2f4f3a20856bc245"
    sha256 cellar: :any_skip_relocation, monterey:       "8a71e7ee6715f6275faa5541417936089622338adff5ce94f18da640d538fc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57d01e1e5220e01e53797df56182a9bacc0474c02cbe3170d92785a50cb0ebfe"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "github.comdockerclicmddocker"

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