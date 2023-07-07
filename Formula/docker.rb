class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.3",
      revision: "3713ee1eea0447bcfe27378ad247c7e245406f04"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0361cec07143b7daffca8c0805adfceed25acc06874cb1f92d6f556bdfca788a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0361cec07143b7daffca8c0805adfceed25acc06874cb1f92d6f556bdfca788a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0361cec07143b7daffca8c0805adfceed25acc06874cb1f92d6f556bdfca788a"
    sha256 cellar: :any_skip_relocation, ventura:        "62c08f5acf2e664ea940ba5351757bd54407f31b3874f291cfde35e95fe592cd"
    sha256 cellar: :any_skip_relocation, monterey:       "62c08f5acf2e664ea940ba5351757bd54407f31b3874f291cfde35e95fe592cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "62c08f5acf2e664ea940ba5351757bd54407f31b3874f291cfde35e95fe592cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6750e3e24ecb2157d13d527398840572323688a746dca2ebf38e979e4779286e"
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