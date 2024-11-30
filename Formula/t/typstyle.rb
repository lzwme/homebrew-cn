class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.5.tar.gz"
  sha256 "1dbc3282ba83c133892a96959d3c3e759b25fe58c9a4ec378d38cc6408ce7f80"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb0d4d3f9ae1aace849c6fd90801560e73ea3130c01ce5311a25382e28dd9fba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0d21b50aec540d2e046db91926ab02b0f5a8fed06e1fdd2813216f6a9d43d4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "908c2453844f3608ff0e0d7fac1f830e84204451b40cd3759a56a2bbd61459b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "800ddfd0f25fe96e89e390a6b5f8256cf70876e24c6160dea4a67b41c694a537"
    sha256 cellar: :any_skip_relocation, ventura:       "d4d54da2c2c8d678db8381ca3548022114326e37645a7882118b90a09f6e4912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7501207efa76af9f881857a7a53a84df3bd06601f782a62c2b1c27d74d1bcdb2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end