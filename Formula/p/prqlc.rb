class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghproxy.com/https://github.com/PRQL/prql/archive/refs/tags/0.10.0.tar.gz"
  sha256 "d279c881d9c8ca16b886be58fa2e8a12c2e708ee40caf605b688b85eaf5c0319"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee62d3c6bdef554fa9689ab8419f5a12ba72570978f3ef2d2aa6ce93ae4fd11a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "680bf007026c7b00b8338ca9985342fbe07217d6636fc9b41faee4877b38674a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "125f5c55dfec328a190fd809d346e963444e66959f780fed860b0157c0ab75e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae5f7f08218cb419470f4756fee438b9cc64dbb6d3b2b1a303e3c2fcefd31c56"
    sha256 cellar: :any_skip_relocation, ventura:        "d423701a60c85241f9a7547f233bce0cf3798f40d0304e50aee425e5ab638440"
    sha256 cellar: :any_skip_relocation, monterey:       "49cab62538c308764f1b7ce243da63299b026530628850cb1358ab58def756f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "774aa98bb586f8fc26a8d385e7176e409354cba7dd4f7a429eb95ad51e167dcc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end