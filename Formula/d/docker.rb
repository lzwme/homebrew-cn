class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.0.3",
      revision: "7d4bcd863a4c863e650eed02a550dfeb98560b83"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ad622cf5c278035a9a132beda250bd1e62933f82c4a5ccc473ccc793e7d0f6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9994a13980f210d45efaea793fb698d41e94d14af400f7644e045f5ee88c3049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51dfa1530ab58dab6f05e26c5687f024886419914fb85491b2dbbc78c3e2719c"
    sha256 cellar: :any_skip_relocation, sonoma:         "20588fc4264655167d99d57a358916eb48417b7fb91bbafa94aec01ad8a2f3f0"
    sha256 cellar: :any_skip_relocation, ventura:        "fd35e0f5a4bb58151549428335d643c1f6fbc84b9013b7ebc3ead3cb098167e9"
    sha256 cellar: :any_skip_relocation, monterey:       "1194efb9c9324bc12f5ead867ad88a8ae18076764fa90b9df2e0846aac74c446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "160f4057015e587b0608dfb7a94f17cc47c225f549631491a2820ebb70914225"
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