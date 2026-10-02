class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "9cdeb1c799fd2d80afe090aeea5c12942ab7fa43a42915fc33179acb473809b1"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb47a86c7b0bf887286391656c46906e0d4095552471a413d767fe3de1a8d698"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb47a86c7b0bf887286391656c46906e0d4095552471a413d767fe3de1a8d698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb47a86c7b0bf887286391656c46906e0d4095552471a413d767fe3de1a8d698"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "321ec8ee30c46ae598ea854175de1ebd5d5aa4bbb2294e5af821ce5c0eff5294"
    sha256 cellar: :any,                 x86_64_linux:      "f405b9eb74e3822fd68933ad3e55cd01628d24b401d6f44753ed7319601534db"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end