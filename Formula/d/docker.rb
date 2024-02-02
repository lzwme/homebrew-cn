class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https:www.docker.com"
  url "https:github.comdockercli.git",
      tag:      "v25.0.2",
      revision: "29cf62922279a56e122dc132eb84fe98f61d5950"
  license "Apache-2.0"
  head "https:github.comdockercli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef17b8d3960f2b4f23b307d942e9ee58818d56925e4c4ccbdb15c0cda5dfd3c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bfd1cc7556117e915cc1f0a1685c46146d3435fcc7241adea4bef36f5dd5dfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b0da1b18426f9eb7219c196d621406d256ce4209738f8b0910ebe5cf0740d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa57b66a85ebefcda071d48d542b2a3c60e981b0da30d115c1ccd774bb19a660"
    sha256 cellar: :any_skip_relocation, ventura:        "0b319b1834e42981747caf8d44ce6aa7a07256fdf3c951b9730c6aab4dd7c149"
    sha256 cellar: :any_skip_relocation, monterey:       "82b0e5bc43ea64c77758d54ff7b1914afc412d56de625e6bca94c6eaf131a42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b4db6bad445fbc9022990b27112dfa473a53a82f5f93c3129c611f3bc440cd9"
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