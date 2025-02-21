class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v28.0.0",
      revision: "f9ced58158d5e0b358052432244b483774a1983d"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd998255908222eb848970f978a0ee57f3a63fc8e81e56a7756ccd38088bc535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd998255908222eb848970f978a0ee57f3a63fc8e81e56a7756ccd38088bc535"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd998255908222eb848970f978a0ee57f3a63fc8e81e56a7756ccd38088bc535"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d689950228d9e676224bbc9a7be9ee72b4200f053339ed5b60eedd19292aee5"
    sha256 cellar: :any_skip_relocation, ventura:       "4d689950228d9e676224bbc9a7be9ee72b4200f053339ed5b60eedd19292aee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4854f5ef50b9d84e8ad34057889af00ec690938b244e338a29a420a9a56c690f"
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