class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.3",
      revision: "3e7cbfdee1eb5be2ac23ed3668c654362dcd29b5"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a4f7f0d7693faef6e4688e3bde6a53f377af1549ecfcf15be078cd7a6599228"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a4f7f0d7693faef6e4688e3bde6a53f377af1549ecfcf15be078cd7a6599228"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a4f7f0d7693faef6e4688e3bde6a53f377af1549ecfcf15be078cd7a6599228"
    sha256 cellar: :any_skip_relocation, ventura:        "f2030ab2e65c3d4c2faa45c3af677635db6b3b9b822da566dc0b1bda04727203"
    sha256 cellar: :any_skip_relocation, monterey:       "f2030ab2e65c3d4c2faa45c3af677635db6b3b9b822da566dc0b1bda04727203"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2030ab2e65c3d4c2faa45c3af677635db6b3b9b822da566dc0b1bda04727203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09a69bde203735f07b30ed19769f0cd0afb6585f0736420ee1a81bd2039e6328"
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