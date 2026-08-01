class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.7.1",
      revision: "e9452d6e785f6e365712b9d71bd7517591773c86"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bc0f3ce68c682ff23050b964f9a721b15fa1524ae29129c02c96d3966e98dcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a726caa9734771ddd608a9ca7eb8456c51cba598f2e16018d1373416c314b27e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f216fe5eb3abfbdb01a6ed3770dfbf013568c5e262b31c320fddfe6a7c4f099b"
    sha256 cellar: :any_skip_relocation, sonoma:        "375c85eed3986ac91776e0f9de489d1e7757beb1fe34d4a36b0e209448df6ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db9ac6a9137059cf4586466b376816e6d6bba9cc49f0c6ba0cbe81552faf4562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58594631e27ae9c6d30c83f85a825be528e63e822ee58d9a2206a304675092c2"
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