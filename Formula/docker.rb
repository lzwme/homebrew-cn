class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.2",
      revision: "569dd73db13099a7c3104d73aa15117b359045bc"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01e9a03a8923d4579279821af5e0177c7e5e560ddb8ba57c2787eeed195fbc26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e9a03a8923d4579279821af5e0177c7e5e560ddb8ba57c2787eeed195fbc26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01e9a03a8923d4579279821af5e0177c7e5e560ddb8ba57c2787eeed195fbc26"
    sha256 cellar: :any_skip_relocation, ventura:        "794b05560d4d737cb63deffdf12aeecbfa005bb71b694c6cbed4cd022eb58ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "794b05560d4d737cb63deffdf12aeecbfa005bb71b694c6cbed4cd022eb58ee0"
    sha256 cellar: :any_skip_relocation, big_sur:        "794b05560d4d737cb63deffdf12aeecbfa005bb71b694c6cbed4cd022eb58ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "019cd705392d171ab775ea7ec6b7cd0f5f803156fcd5c9f0703d0fabc51770e0"
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