class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.5.2",
      revision: "79eb04c7d8e1d73247cb7fe011eecc645063e0f0"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd87549832caa868fc769b2ddc9a0142297af04f741685f1e6213c459525ca57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bcc923f7f78a07188230a6f044ed91cf008739e3c799f5c80d3419a03585e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4900e3000786beac086d8ddd8f55dddaf7eeacfa1ed8f2d4f100bc8a4ac40cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b0db7da24a1713e9d83804e69571c0181bfc2d6b9b808570ae049b77e4b4b67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "366cbe02beb75ceda26392b849e037c08111117f5047f32f2f9cbccee2ece328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d5d44efb6ade00bb3aa96f76884382023a6096305cbaebbaebd70b30451218"
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