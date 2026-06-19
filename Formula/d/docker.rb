class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.6.0",
      revision: "fb59821d450bc76c97e52617f66dde0c6035e332"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1ef6cff1bd0ec298a983063171548848c67f8826b4edd09e767b42f2e569bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "451568b1bbfdf29b434e0a6a4d852c24483156a6a7772105ae3d45400f55f13b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ae6e6c17407f53a7919cd501c9d9e367bdef47a2144f76956a8aba3f58aa4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d7ff56eac9eb081cc681f6623eaf9866378f33843e198269e93316799e0d8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48286e3d11ef718a0d457957c373b320f51a215fb3e22e3dfad5026ca78c86fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "875f66f0bfeba67032c6333dd2084e66ecf483eb6d62eb3e15126c5972987605"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

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

    generate_completions_from_executable(bin/"docker", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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