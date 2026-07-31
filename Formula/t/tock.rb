class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "8b196c85a133956d61db45efa83fe8cdf9797ee65b526a6bfdf523971b28c2b5"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "339b1df88fa899397156ecbfff34e1a98d052a0240b7361cb3c8cff70dc2bf37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a235080d499ef1ce9ced62e598e547b4f63914e608d46ba1559c4931b5b9b6fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93c1d2d401a35b45e9cc53a2c1211ba312b2e5b67e645d00b4e6d814d05b8cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef008a0798ea3d784ec98371d054754389361225fbcd69b4f3c23fb45b705d02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfb5f0915706dd32a5841fc1d1bf26b030b6ddd69041a0436afb554f53cd4ec2"
    sha256 cellar: :any,                 x86_64_linux:  "808575d03cb90b9a1711b2de2d667c9645dfdfcffe42e7a85afee1138c4f4b2e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/kriuchkov/tock/internal/app/commands.version=#{version}
      -X github.com/kriuchkov/tock/internal/app/commands.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/app/commands.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end