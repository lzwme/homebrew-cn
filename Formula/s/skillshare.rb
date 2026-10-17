class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.25.13.tar.gz"
  sha256 "7967d9d38b24d05b06e11520a265412b6df6b76456c676038d50725d8ddee855"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3be0f89efd199a0598064a7dfcd071a76a853bba443e42b5c7f342cbb2c116f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3be0f89efd199a0598064a7dfcd071a76a853bba443e42b5c7f342cbb2c116f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3be0f89efd199a0598064a7dfcd071a76a853bba443e42b5c7f342cbb2c116f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8ca62de7945cb4b770fcc0e702ae3b7a8feb615409a021fb1123b635655ba65"
    sha256 cellar: :any,                 x86_64_linux:      "f677d78a95037f4b325b8eaf48c10166462549def3b9fde9d7e79b9f839eda01"
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