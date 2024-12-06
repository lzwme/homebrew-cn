class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.3.1.tar.gz"
  sha256 "1fe7ce3c6c9514a96b422206916c8a2a98b5b9e9aef05a961551efebd551cdaa"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2acae0a4a2a7cafc7ff1df9eda82472ecd4e3f5f86bf6162249ef9b0fd8cf844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec4425070fc1228d15bade4fde823513cca22e123e754b1320ae6d091624d93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc8b2f94dd29de60bbf9368898e0109b31b4c60a9581b6f2ec0d16dabd84dc1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b189da030fc4355b3c778517b236448a7e95581781544c4167a11723ddcedc6b"
    sha256 cellar: :any_skip_relocation, ventura:       "717b663c2ffe584579f4eb2c2085bd31f020765cbe95af8adb37ba98b7512229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9c7784582c1150da95cd7bf7e98b099b3cf35b5b2f95517c7ef5bfb28d052ff"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comgrafanalokipkgutilbuild.Branch=main
      -X github.comgrafanalokipkgutilbuild.Version=#{version}
      -X github.comgrafanalokipkgutilbuild.BuildUser=homebrew
      -X github.comgrafanalokipkgutilbuild.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdlogcli"

    generate_completions_from_executable(
      bin"logcli",
      shell_parameter_format: "--completion-script-", shells: [:bash, :zsh],
    )
  end

  test do
    resource "homebrew-testdata" do
      url "https:raw.githubusercontent.comgrafanalokib286075428a6cc7f58040bbdec6c81a97b626852cmdlokiloki-local-config.yaml"
      sha256 "2526c97ba82915499d134d8fb6f3dad2828065531818ff94798b36cd9a59e8e2"
    end

    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "tmp", testpath
    end

    fork { exec Formula["loki"].bin"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}logcli --addr=http:localhost:#{port} labels")
  end
end