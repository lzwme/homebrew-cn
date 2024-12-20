class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.4.1",
      revision: "b9d17eaebb55b7652ce37ae5c7c52fcb34194956"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "947bd4af3d3a0407704a0cfd07ffde2a1faf49739b9ab4f7cf340a53a428883f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "947bd4af3d3a0407704a0cfd07ffde2a1faf49739b9ab4f7cf340a53a428883f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "947bd4af3d3a0407704a0cfd07ffde2a1faf49739b9ab4f7cf340a53a428883f"
    sha256 cellar: :any_skip_relocation, sonoma:        "296374e691400e7bca78633950976032a1b1630b9bb0a6a6cecaa31e071ec7f9"
    sha256 cellar: :any_skip_relocation, ventura:       "296374e691400e7bca78633950976032a1b1630b9bb0a6a6cecaa31e071ec7f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21de6c95408be15a666f2ab6044d66af27b8ff78ed4653ac5941308136b0dd7b"
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