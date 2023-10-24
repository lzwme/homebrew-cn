class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghproxy.com/https://github.com/open-policy-agent/opa/archive/refs/tags/v0.57.1.tar.gz"
  sha256 "c864e240cb339559888e85a15866e60521908380771816ffdd169b3c6bb66dca"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dd6f241524b46b3e181455c7ecc44e4f8f7c725f62c1d83328da5021471ff72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "478e00114aba8cc190533cf5ac2f8dd3be92dd629da6c54c8c5e1ccb6c54ee83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e80757e16ed1d205ce2a5323296f33d0b5ecf3c61a6adf34a09a3ed75197d585"
    sha256 cellar: :any_skip_relocation, sonoma:         "9575663103214fd2f2c20e6f5be697bd95fb8be5c106de710a553e3598040e57"
    sha256 cellar: :any_skip_relocation, ventura:        "343b13a4c1334de8527292523fca2dc32ffd451661f243cc0ef5204a7c715455"
    sha256 cellar: :any_skip_relocation, monterey:       "22e48e484f410dbd14ef5a13f53e4f04bce739f9ead63f187cdbd5838d15b2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16782e60f41a554cb0c22f5db67d5058bb4478a3e8179843869ae5d2fa8a7b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end