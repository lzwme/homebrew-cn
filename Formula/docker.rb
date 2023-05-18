class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.0",
      revision: "98fdcd769bcd137f7538f898b37348f919536ea4"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11f1c303c003a575809e617037bfc0014ab438ced6bb60e6f5a49b998a32f1e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11f1c303c003a575809e617037bfc0014ab438ced6bb60e6f5a49b998a32f1e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f1c303c003a575809e617037bfc0014ab438ced6bb60e6f5a49b998a32f1e1"
    sha256 cellar: :any_skip_relocation, ventura:        "411cec90576675fa611fdc7606c5ab963a7b1e274edaa2e7516dcc31aff15c78"
    sha256 cellar: :any_skip_relocation, monterey:       "411cec90576675fa611fdc7606c5ab963a7b1e274edaa2e7516dcc31aff15c78"
    sha256 cellar: :any_skip_relocation, big_sur:        "411cec90576675fa611fdc7606c5ab963a7b1e274edaa2e7516dcc31aff15c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee1a76c8765875fece0a73e8c66fdfd33a3e74b11d4ba5d389a63b731758a1b9"
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