class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.27.0.tar.gz"
  sha256 "8060d480f9470db1d850f2b6573693df0df76b61139ae40c37eba8ef1b8c2dd3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bba4d75077df76ff162e7e0f2af61d4d0672148a3909e878dbdfbd7055fea15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87a1a7a2a14d4e653ce0007067f9f06a959e85fd70686e5def7f2848d4b78327"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64196194e66c4edfd7c60e7298f136f0efc41d23eec0dc3846625e051ccea0e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a79b740923018eb45ed4f0755fd682eaa532fc311d135ef31cceb2cc9aa481c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee14a4cb5b3994efe2779bd19fe401b069529a56e2f5bb3c5ddac636a87d42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7581b8d40bbeaaaefac1d13aa18b050a5357ae514a03d8edb5a01b81eae1c29"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Missing required configuration: DATABASE_URL", shell_output("#{bin}/ironclaw config list 2>&1", 1)
  end
end