class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.2.0",
      revision: "0b9d1985dbf919678745f122b12b46f730b97d87"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56227314c3d95bb9b6da8a0dc48d67550da2aaa1e1aa6213cf9f3fe235eae0d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adbe85558b44f32610f473427e494e4191d8f6019b9d79b20afc43e273a5d5c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a56cd22e7d6247d480982dc5f1cc0fe0d7b4f5c2eb973618250bccde1b06d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "31a3ee3583481be5f1032f584d6cdb31f9a13edea60fd33fab248241f5ec81f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "845973293fe48338a6aa48b9c7fd2436c6be87f6f3cf8d5aa0041c54aeb91b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969d1b46846ee54610a41944cc13be16db8c74be242cb01daba656c3af5c86ef"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}
      -X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}
      -X github.com/docker/cli/cli/version.Version=#{version}
      -X "github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end