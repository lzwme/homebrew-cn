class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "f6849daa93cb12432c6c000e061475aac8f05fdc640ddfb7747a3609922f5211"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1f84e600f0954a1e3180edac393053985f5c194a23997aedb342ab937cb0609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d2a760926697579138890304a52386c94a328141d3435029855a298603f058b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83060a94b1fb5168e351133bac8c7ee239892875807614f9642de4d8890374c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cbcf28b206208864462ff189fd65331bb798e5334b1f8e1d9038efe971bb7f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1da7f99b24e9b65781d49c9ca9e80d030f98a0efe0f1d56112db3080ad2b0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cb90ea752aa7442c0e0fc4107ee0d04a9977d59e8403df863884bb9c5ab6837"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end