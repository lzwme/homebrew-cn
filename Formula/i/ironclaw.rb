class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "0ab3ffd78bea6ada2c4c3e7a9ccfe0265713cf37c58268e33280f00ca3ee2ae4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5b90bb399355646d848f5974f11142d92ef2372d75b24b9e852d56ea57e6a82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca751bb356cede37a94a84f3437aea863479c53a60c3efa03def659234973885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6bb46f0dc8827b662ee5a3e48b2fedffe22f98eb94202ff0759b068c307e9e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5993d5887b21c65755c8099195d466aa3951f4e4b0523a4acaf9ad32f2d0d60f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fb1a86f7eb324246413af0fbe8adb2b2e9e68b518f6d7158030f2673aa07828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf4b1c6612775a6fda0fc0ef5a858eb3c8e922a8b215074799715a517abd972"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end