class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "77bf42ed7b13b71534c3032fc9f396fbad865f532c0447bd0ec6f44dac3a56f5"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c4a93d9bf2fc6c4a3d0aacf9b9c319dea6bd1ee2d8db9210165dc8da642ace"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2f8d238445a8965f833dd76b5e56889a0bc148af7229d0d8d23162da9cbb266"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7eec63203cc848ac9a94de7841be75c133af0a1857b3934dfc9f4aa7c0ba26e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c26492229f964aa1cfe8d6f1ee4d67c352c2e1eb11fa2e0b53cec041db1028f4"
    sha256 cellar: :any_skip_relocation, ventura:       "60cb5aa3bf3006e8b4281e69473e3d65d6b6a0cd65a8b8030d31696100371d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c3cb50e08f9f3e2cc1ce12d0fe1cd89c84c0a581c87cfdbe578ffcb6b31271f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6434f359683d7435e1c7e0f5efd096e2658fc6c836d9c555763c5ac7e1af9f47"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end