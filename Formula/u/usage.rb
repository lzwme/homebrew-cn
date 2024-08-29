class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv0.3.1.tar.gz"
  sha256 "0d83f635e5ba75f09f16c8481d3bae644e48b077cc6aba36898b1500d030b346"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80df4d1dd979d58f255efe6d061d8611111a280b2ecb2f8051d31a219ca69113"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe9a3c486729be70d6c91cae69a9ac3cbe8d263906daf0805e5a41dd81ffcadc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcf46eaaea8e47237627099e2b9fa4cb33a143398aea541f5316e744ff104178"
    sha256 cellar: :any_skip_relocation, sonoma:         "58e8649f6890ee7e7c0dd124de05fe646bf81217486da1289826e67d7cdf7f74"
    sha256 cellar: :any_skip_relocation, ventura:        "f52107aa87acebe45e5997d67d16ff382b1d0f4ea571c473e92e38300daee8c1"
    sha256 cellar: :any_skip_relocation, monterey:       "2a8c13335482cd56c52332501b47e351a38e9e70d7ce4f55c3e4fb4053a35fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da0ede147d944b721358a5577ae321d686be53e20349b0f2283f68ad41d445da"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end