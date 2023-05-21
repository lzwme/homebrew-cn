class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.1",
      revision: "680212238b47d4299b62ed55e3113a498cde3cef"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e785d858b7d64c1e0f5292c2478ed4bfe1773c261e3aca4611a7be612ad2fec6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e785d858b7d64c1e0f5292c2478ed4bfe1773c261e3aca4611a7be612ad2fec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e785d858b7d64c1e0f5292c2478ed4bfe1773c261e3aca4611a7be612ad2fec6"
    sha256 cellar: :any_skip_relocation, ventura:        "afbce2ea98b4feaec6fa42647f7d7757e09f2c073b9378c9e3e4012898e32ad8"
    sha256 cellar: :any_skip_relocation, monterey:       "afbce2ea98b4feaec6fa42647f7d7757e09f2c073b9378c9e3e4012898e32ad8"
    sha256 cellar: :any_skip_relocation, big_sur:        "afbce2ea98b4feaec6fa42647f7d7757e09f2c073b9378c9e3e4012898e32ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3212a273bd090ee308b692b8f37c1226e6dc80476e89d775c55a5e6259f1afa4"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  conflicts_with "docker-completion", because: "docker already includes these completion scripts"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"").children
    cd dir do
      ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
                 "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
                 "-X github.com/docker/cli/cli/version.Version=#{version}",
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]
      system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

      Pathname.glob("man/*.[1-8].md") do |md|
        section = md.to_s[/\.(\d+)\.md\Z/, 1]
        (man/"man#{section}").mkpath
        system "go-md2man", "-in=#{md}", "-out=#{man/"man#{section}"/md.stem}"
      end

      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end