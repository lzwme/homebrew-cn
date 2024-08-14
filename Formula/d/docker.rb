class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v27.1.2",
      revision: "d01f264bccd8bed2e3c038054a04b99533478ab8"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db8687f2df6b1e22271be35f26543af7aae7edda36710fa59e324d4931321fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7fa9e6cdd8373e4273e40ef8e6f45712e256d05f7718d9ea33e00160c9126cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c85d467f6e7298c9a267d550e1d0655f5f495a5f768cc8bb8be3491e08c6cd95"
    sha256 cellar: :any_skip_relocation, sonoma:         "5da70e74096c17ab09e937a2254beef9d7d2c633957ff21000bff5d396c3ffe6"
    sha256 cellar: :any_skip_relocation, ventura:        "f1f5e427c79ab5d7d51ffa6dcbbfcfc248cae037cca0632c4060b3dce231a2db"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd8a26236c01ccda274b46b5f81f3802bdf04bea042ff544ac776c20f689f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb7bc3d2de8054c1cbf3096e965d2d36ac655a433b5c2d085def040f850f5db"
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