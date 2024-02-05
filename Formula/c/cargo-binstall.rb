class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.6.2.tar.gz"
  sha256 "4f8e74af5207e769f5cbd8c9c26e6cc08b8471ffd4211984e7f8ea73a53bc1d7"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "037aa9142849fcf4491bfc94fa993c65d68a8453388a5aeb924911b2a9961c3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7353105684be871aa470d894f78399147775bb47efc03819d5fbc0c5a3c2f0a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4860c05972f6f2c4ba5de79957ec7f5813a418af85577d82fbc75977667e1c89"
    sha256 cellar: :any_skip_relocation, sonoma:         "032fc370cfc1119799de0289c8344ba78cdec77d3225806c53d69d0e6bc30342"
    sha256 cellar: :any_skip_relocation, ventura:        "a9db168e40134c72ecd34a8eb55acadfcda459555ef19aaa5ca6c6158b9d58da"
    sha256 cellar: :any_skip_relocation, monterey:       "d4dd8c9ab2ee2f80e2a292610b32e24c6ece985ab5cb9c69a951d0b64e809af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8fa73838ca07154c21095b0c1406006df9e498fff8d08307fbd51d29c3c27db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end