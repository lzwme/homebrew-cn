class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.39.1.tar.gz"
  sha256 "8adfb009d74e84e0add5ac6b652f40c5022120fcf1221ee0c02fa5acec317f13"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6a67e77b2eb9a779aa7747044c219e4fb821761f398c3146dcfc275133a170a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baba0cc73f52dcd640d3c35fb842bdc9292f1105af334c37d1661416f45b3d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b1a09fa0e75ab6b95de4c1a0afa0cb4dd28372af7f5fa842acdedf44cc5bb89"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf3e6e5c761ba67fa94c9aee5e194950ce73b0b6c55d50c7997563aeaff95efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "859e5843b365c70010572cbe780bbdfbee758ffca12a2d37dbc6366dab74cac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a69dbe39c4d4f49bf78ed16884f3074b2885dfcdf3c461bb610b88711b4309"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end