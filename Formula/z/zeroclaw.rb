class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "309cac6640481e7067f5cef041b83b13b8cdd7ca6747a5bf4a461a6b0ea5246b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b456f9aa72a0668f067d1e2970820f73c4a76fd821a51e4e4c106bb4eea9a33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb39b495cb7d1b9a05efacadbde02478e9293ef203f009f55f62a295aa53eb52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "966fe88f63f8d8c864e7250453b1ac0479bebf8fb990a46cbdf2931e132cf255"
    sha256 cellar: :any_skip_relocation, sonoma:        "571e6a0d14fc810ea14aa3db24ec220faff51247ec98c9c5efd1a03bee56570c"
    sha256 cellar: :any,                 arm64_linux:   "7a31350a5e4b0148574d067e8433ea5fbca1096723faaff8e77dbed92f65e022"
    sha256 cellar: :any,                 x86_64_linux:  "c37906a23c1ebd1d9dc5eddbfb1b21fef5a385a59fc57a1ab2533071174bfa96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end