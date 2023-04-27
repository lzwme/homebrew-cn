class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.5",
      revision: "bc4487a59ea927322d96a0a0876dd6047f82e72d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a0a8e7a1901538968871b342db7c7b1e056bd033cb294ba950f1c69f2065363"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a0a8e7a1901538968871b342db7c7b1e056bd033cb294ba950f1c69f2065363"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a0a8e7a1901538968871b342db7c7b1e056bd033cb294ba950f1c69f2065363"
    sha256 cellar: :any_skip_relocation, ventura:        "aa59d361b281969c46896ab353c91db81e2e0b5591259acd816741c92a62397b"
    sha256 cellar: :any_skip_relocation, monterey:       "aa59d361b281969c46896ab353c91db81e2e0b5591259acd816741c92a62397b"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa59d361b281969c46896ab353c91db81e2e0b5591259acd816741c92a62397b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7189c38b58d054cd8d823feea4c1be1d94f42220a1deaa5198d5693cac5c6c09"
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

    expected = "Client:\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end