class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https:github.comOpenIoTHubserver-go"
  url "https:github.comOpenIoTHubserver-go.git",
      tag:      "v1.2.7",
      revision: "b4429c6879ad1851b32c6ecad4700c746406c72a"
  license "MIT"
  head "https:github.comOpenIoTHubserver-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61a2b72157bb1f0c1da43ad41fcd89e924c702d7e9f0a98e205ccb24910e1eaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61a2b72157bb1f0c1da43ad41fcd89e924c702d7e9f0a98e205ccb24910e1eaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61a2b72157bb1f0c1da43ad41fcd89e924c702d7e9f0a98e205ccb24910e1eaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "05445f8aa0378be5c7f1eac736c950695871870aec1f03bfa561bb49ae848e6d"
    sha256 cellar: :any_skip_relocation, ventura:        "05445f8aa0378be5c7f1eac736c950695871870aec1f03bfa561bb49ae848e6d"
    sha256 cellar: :any_skip_relocation, monterey:       "05445f8aa0378be5c7f1eac736c950695871870aec1f03bfa561bb49ae848e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403b8cb974d99705529baa85d73c73a04a705d8556a8b5241015c27f8ab6de65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    bin.install_symlink bin"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-goserver-go.yaml"
  end

  service do
    run [opt_bin"openiothub-server", "-c", etc"server-go.yaml"]
    keep_alive true
    log_path var"logopeniothub-server.log"
    error_log_path var"logopeniothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}openiothub-server init --config=server.yml 2>&1")
    assert_predicate testpath"server.yml", :exist?
  end
end