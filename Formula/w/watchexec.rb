class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://ghfast.top/https://github.com/watchexec/watchexec/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "ad87aac074e5d1b018bb50ef98240911cd31d96d68d9b8ac0f02c14879930f50"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "acc0f85501c5fdf0588a2c2726dc30972f7d364bf2034e294a9b421323f7fd04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d658053d02e8576b2fed86fb60e57eeb07805630eebd8d1592a6cac2e4ecc63a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99fe0d815cc2d98ef4585bed73928878efa2a367a3943cdadedbea3688751501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "49f61e9032c2961e6e555e01ad50c6c658e407360d28b677dba3cd818d8e3ef8"
    sha256 cellar: :any,                 arm64_linux:       "e6b45c9886704d864fcc3bc872d17cd9f6eb51fe7c5c81bdd0ba776f5dbf2d21"
    sha256 cellar: :any,                 x86_64_linux:      "03dea3bb8c4ce185e30257f95e5bacef80fd8363eca6d583f92fe80c0ca166a7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end