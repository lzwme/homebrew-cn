class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://ghfast.top/https://github.com/ignite/cli/archive/refs/tags/v29.3.0.tar.gz"
  sha256 "2fe85bec70e0bbb506759f08b49993da6599358f9d037226acf859b27cd5057f"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877fa1a28851037d85c383f6ba8a72251392efb8334466f487d1aa07199b7244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14abdc5c9e6fa6e32e24741d6928271ed4379979823adae495444048cc41831f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1ed6427f19b6da17ea4d13b65c68f3a4e245072fc3deabfb02e72f1d2366989"
    sha256 cellar: :any_skip_relocation, sonoma:        "6697ae815cf991e0e4d63dd533d58912e6f367ffd3723b81552dcaef2475196f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "478824202465f145db9e5036517032926e185238df10128be4006b6b15aa21d5"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end