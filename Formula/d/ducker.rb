class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https:github.comrobertpsoaneducker"
  url "https:github.comrobertpsoaneduckerarchiverefstagsv0.2.3.tar.gz"
  sha256 "62af04ac787545d7135f39a1fac456c18271ef67cdb4786ee387e724c9666201"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ee7169b771974cc316e0e6de2f15dd6648c8fa305502a8a368c31fee0dc24fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d62026903deba474f663cf405641c8b1c2d21bbc27e43751b91d7c0ab89a23a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3e6af91bfe45fa77ad7c18ef7d4a919bc2cebe88d12a4b6b378231f456964af"
    sha256 cellar: :any_skip_relocation, sonoma:        "88c87bfbe14f7cf23f056da7c6f115305de49c5f6b17338516be5db3ce488579"
    sha256 cellar: :any_skip_relocation, ventura:       "4e5e95f1fcf494c84d1f2514ffd672fa7f0f315b4a11d4a4204a3bcf4b16d63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60d583ba53b6a622a7e14b7e32a9f3a2a9b861ff71c9d4fdc292f22676ec089b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}ducker --version")
  end
end