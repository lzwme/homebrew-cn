class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.5.2",
      revision: "79eb04c7d8e1d73247cb7fe011eecc645063e0f0"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67c1b6eaacbc6f4637c4aa6206a74f7e7ab9cf7b522ee0845f170f8bb2f53820"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6689c2cbec6e37f37f9710652f01b49dc1f21c00b1920f346346d1b264ad976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38d25ff7d588f8480152f89e2177e3a91e10cd4e1738c3b45347f57acabde1b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "87320c07cf4a823d89eab0f58e39c528375a1ed0e4c5622aaced68ec3a5f38de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82fd1665d954f502b3f76d00a2145e734847d2c621dc03f5b6eaf9164e4b0fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ee45e00a7bc8b980a41c0c48e8a502bb9c6b6839501c1b4dfdce5ad2ba4dbf"
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

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install docker-engine
      EOS
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end