class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.14.tar.gz"
  sha256 "e68b8def5dd019768dfd0f687a574ab338b66a8d7994152a334af675a5aee62c"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddd2751b998296cb6744e2488380a14f44b42c195809fcc0ef0db3735fe51a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddd2751b998296cb6744e2488380a14f44b42c195809fcc0ef0db3735fe51a72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddd2751b998296cb6744e2488380a14f44b42c195809fcc0ef0db3735fe51a72"
    sha256 cellar: :any_skip_relocation, sonoma:        "06e1d7debafce5b0964f90c4b716a705b5f57e3417dfaabb36a856ad021b2a15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "439aad3fed2159daedea8a9609173f3327d9d5e518961b9435b49d5bb329db9b"
    sha256 cellar: :any,                 x86_64_linux:  "0c1a4d30ad30dd964376d3cad7665ff72454e464ae9e77e7047e86364ede3a07"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end