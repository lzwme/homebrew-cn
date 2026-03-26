class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.3.1",
      revision: "c2be9ccfc3cf0b4c4c4f0a3d5c91dd759ab21256"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52b07f0870600eed407ffb126d5301e5ba4ea1296e8293b339c206a7431d11da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5472dea4dc562dc908bf725b7c6990975ac92c560c5e0a515492d093ac9cc617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "355576e65f8ef03a6c02daf8d73691830dbadbddd72b0b5c826c5eac9afc5c20"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ea62227e1fc40f143b436205da4a04302650714fb1c57b5f443ec01640ce087"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdabf7498cbc118c274abfdb7d18186071f4fbf2121b7df1705cd027b909b0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aca877083ff3d29b1b54517f95626ce3e1472ba859b5399dc3812e338dcdfb2d"
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