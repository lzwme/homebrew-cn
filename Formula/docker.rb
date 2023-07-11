class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.4",
      revision: "3713ee1eea0447bcfe27378ad247c7e245406f04"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aebca2a7b993f513a1c4d9a53adafdea93c7199cd0dcc36ba9d2db3bd6e444d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aebca2a7b993f513a1c4d9a53adafdea93c7199cd0dcc36ba9d2db3bd6e444d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aebca2a7b993f513a1c4d9a53adafdea93c7199cd0dcc36ba9d2db3bd6e444d1"
    sha256 cellar: :any_skip_relocation, ventura:        "e2f81f2df451b84ff42647ce1afdb4c5df59483eb927fc551badb12245af696e"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f81f2df451b84ff42647ce1afdb4c5df59483eb927fc551badb12245af696e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2f81f2df451b84ff42647ce1afdb4c5df59483eb927fc551badb12245af696e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037cf3d782a554ce510c9f1de766831b445f52d2958c6f9ef83f198aab36104a"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  conflicts_with "docker-completion", because: "docker already includes these completion scripts"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"
    ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
               "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
               "-X github.com/docker/cli/cli/version.Version=#{version}",
               "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]

    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end

    bash_completion.install "contrib/completion/bash/docker"
    fish_completion.install "contrib/completion/fish/docker.fish"
    zsh_completion.install "contrib/completion/zsh/_docker"
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end