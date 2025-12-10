class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://ghfast.top/https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "63bb34811121e89b2dbe65c047a509926415121cb384ba11e221442f3e536c9a"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b8fe569afdbec2e052e7795b09df251bb6d7209836907bbcf6e1fd90c09579a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19c0c01b0ca19597f8de7e109981db9dee55e1f5facccd1f7fdbb45fb9c6a7f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4334aa624b4075d70e9f122a8be1dc65d0c62b608f5784a066a5e7e9e40b1b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d2197658f5eff1a826b6456be1c02b7f36ad26bd596d841174c82d53e790f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfcfd590261a62cafa2076f71e96c7605bbbd1c8a925fdb10ef665d0e99a22f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680b5e4cdd31ca49743f76250f86d1906e3d7a77b500e7c45a72e5c8910c162a"
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