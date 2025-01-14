class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.6.tar.gz"
  sha256 "405e6f0a53de9df6bbb2383c4cb13fc47db033568ca6591b6e1c1487099ddbc9"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a85babd915f1def10d8cc5b43141fc7e8d8ae26a57e5911e799246ab5f5a2a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cedac7d183ca2d0dbee75d969fb630eec763765d70dafc5ba824d4ba1bebd18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5d6bab0b5efdbe4914ddc4a2561d7e7c4227fd5e58c45996336a007166c552b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdef45867056ca79fa38666e66fbda3e1f59aeb8c00f064c469d3a53053ce970"
    sha256 cellar: :any_skip_relocation, ventura:       "eb4bcfe03ba676598495a7ce3e04b2f91c65423dabcdee8f3705250f0b20bb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7345f1efde0be44a38867657bd1ca31392968f8ec8926e8a30a3cfe623a2cba1"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end