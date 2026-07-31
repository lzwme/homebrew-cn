class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.7.0",
      revision: "c1eba931e3d15d204bedeadeb55ad8880be14ad3"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "180d6d8d871e89e8c65d49acd48c0ac57e5c1f4089337d671e7ee3b6497ae67c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1719d9beb8ec68944bf55d7686d601221fc7c1e6b4dcbfa3c1ff1fb4aee81019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36f549433c0cf5176dd710f55c63b59bb01335cc25eb0bcf2ab16ae4494140cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d003132efaaff80a87c461a7cf50993da51d4e5855cd19b9fecf5588412f8b54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2174046eec053a02bef9a8dbbb3135c6be4f9f7c0a6f5fd0f1b9bcbfc37a346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c74ed8bc4e1dbecba86860b1e4827785bd6d84459055794b08bfd2da20ade95"
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