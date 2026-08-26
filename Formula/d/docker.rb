class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.7.2",
      revision: "a7dcaa6fdb6ed04aacbfdc76357fdae01605609e"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e94049548c22f62264524c00bd2acd2c695e776b942250deddf0e97fd0188a35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0addeb0d226bb91a8d5410119d181fe8249dc7e3179e3a2ecd245995532c58f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8a3900e7e6ffdfe275d7fb96c67c37ee792ae1156bdc0f86784d0afe59b037c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d46d03905a31314e4757746256c261db8e328c4a894e1f637ceb5b8e800faac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfe7e765e0ccf2d9388837bffaf19a9ffaff929b32b17b017a0c489100b24d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d66235029b0c303b078b846c96c875715c15ad56a53319899728177292adee6"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  conflicts_with cask: "docker-desktop"

  deny_network_access!

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