class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "1cba3c26c370464afb142c4446b780b86f0b54f3dda6fd777b0755b78ca939ce"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a85d916a50073316ffb2e217274ecadb92bad9356f03059923f0ad83e100523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "453df338f128662a368ab22f9fac866f50af0afc6cfb98c56d00a5045bd550df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee65fa46ac379fa160f093e6e3fb624996023e3e338f30917f01d65ffb0aa490"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5de83d5b35fd868b6b9aa9bb6f24a95ec604d964e427464c4af26dc631d8bf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38833173c2bc39e091017641db0de0f9bf2e03b68016cd7f5040253fb3b806dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39488908c056be477a36d00a095282db27a62fbbdf752f2f2147686bc2b6757a"
  end

  depends_on "cmake" => :build # for llama-cpp-sys-2
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"shimmy", "serve", "--bind", "127.0.0.1:11435"]
    keep_alive true
    log_path var/"log/shimmy.log"
    error_log_path var/"log/shimmy.error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shimmy --version")
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end