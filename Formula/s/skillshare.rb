class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.24.6.tar.gz"
  sha256 "b39df03a39a9952eca6614540ee0953165f93ace9aefdddc5f477f07d949aeb6"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2060d5ab2299e8bb5ff6c5a810f54724b89a7edbfcda43935c2fcd2a1f6f0531"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2060d5ab2299e8bb5ff6c5a810f54724b89a7edbfcda43935c2fcd2a1f6f0531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2060d5ab2299e8bb5ff6c5a810f54724b89a7edbfcda43935c2fcd2a1f6f0531"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5107ad538817a43f34c566914a272658278f571cfa99b54f37bd2e80520a0d8"
    sha256 cellar: :any,                 x86_64_linux:      "12b3a782742674f72767984415d3a1a19d541d6191b6ae250c2c00d313c85866"
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