class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v26.1.4",
      revision: "5650f9b10226d75e8e9a490a31cc3e5b846e0034"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d34f7a6a30a3540a70d4da473c62cec3e7a6412a5b3719d22550cd9e3c1ccc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d743fa6de9b1979707781dd4ff44b0de0160e5de59388172409f6e7192ea1a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "052dc1f55bb64b161d0e0b84eaf1417cfa1c7a3a42695c3a7c73ab6bf4d1386b"
    sha256 cellar: :any_skip_relocation, sonoma:         "95691abc26751dfc7de05551fc3cbad55c6acea1dce42a60f4d5db16e7a71d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "ac2e206745e1a27edd27ba1a9f39d2760ef3c9f60c94624045e1508ff3e10aea"
    sha256 cellar: :any_skip_relocation, monterey:       "390f07aa240be20deeaef161460bcc005dea38911e2cb6400403c85000347bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82cc2ca5dd93452df97bf87470a1a7b3b89072a8f2cd9fd348edc3c9e0f97bdb"
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