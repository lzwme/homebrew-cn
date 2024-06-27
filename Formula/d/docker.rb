class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.0.1",
      revision: "7fafd33de04cf7d3e8e06900cb022ad65cd12a52"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ab0b725ef16d9766fa46e7a0cb84a2c0f1c32f7b8eef4e5e52f88b3f3b9721b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cde41383fa9b6e57d6cf10b317f6cc77a5b4c44de0e2db3411f4447ff2e4c73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64622f4f9df0bbdc4144e936cbbb0fd5f5dac8335b3e47201654884155b477d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "786cf59fbaf9a2220c8e4e549ec144fe563416aca12c1344f87f1276f065cf28"
    sha256 cellar: :any_skip_relocation, ventura:        "5cd34797695bfdef1028f7239b9e0ea12f8cba8d7c5ddb2959ffa744b8847d6a"
    sha256 cellar: :any_skip_relocation, monterey:       "b069edd94004da8ed7f4cd0533b627ffe59da2c6743422aa2c335363ac54058d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d73aef1df466cdfaf7ac1f3a64edda9a8677c0a5b98ccc937a9c1e3ba54a42b"
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