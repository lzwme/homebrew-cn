class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "408f1bacc4f69e8c06628f08078ba4f382cd2f47ee4bd237bb3e21cf36da79cf"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09cf8d021b2d4c23e0894f6b702f6f86626a5b9331b34d85e430d2cd04010a6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c1325f8d42d74e5d405d01d8b14e77a16dbaf8a9f7ecc57d45f745ecbb90c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8e84c9599f589d8e96f132b27e0c8793a4cc023ea0c554ee0e8e6cbc03c855d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5ea48f5e80feaba5e133bdc65a5496afcd090bce8f363a2b5ac363cfe43c284"
    sha256 cellar: :any_skip_relocation, ventura:       "e448c3db5021dff5296b6f803b8ca0c9570a54d948991a9189263415b16eb809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bcd32535ad5cb643ac5d1225990b8e913b5f0b5527415ddb2613184ded07db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ca0dfb68fbe50536e9cd5c37717126f59952c98304a70499360536a7c64411"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end