class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https:rebar3.org"
  url "https:github.comerlangrebar3archiverefstags3.25.0.tar.gz"
  sha256 "7d3f42dc0e126e18fb73e4366129f11dd37bad14d404f461e0a3129ce8903440"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb10e3dc8527f69fa06a3371f2713bbe1a27d8b027c9ecc123bfa24c8a54bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "605c064817a368734c2a18816e15c6af86617dbf631873b67a4f6821aab3548e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e19920469a8499603597ec87714c1daea780c744e74efa9450581167ae5ca3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "48158178c52845418abd55e85d9abe35a8282386ed28cc9ad0966e0585b1e647"
    sha256 cellar: :any_skip_relocation, ventura:       "50c8bde20fd08c26419ebd10a5ae35e0a4d755508fc57129188269bbc124885d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d30f14ff8806f63eee212e0070fb1c58840a07359f9bed6e2903933a5afa0f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63cb94c5f40ed0279f7410d9d3445e0ce6a9bd0012d6910a76ee1a8928746e39"
  end

  depends_on "erlang@25" => [:build, :test]
  depends_on "erlang"

  def install
    erlang_build_dep = deps.find { |dep| dep.build? && dep.name.match?(^erlang@\d+$) }&.to_formula
    odie "Could not find build-time erlang!" if erlang_build_dep.blank?

    # To guarantee compatibility with various erlang versions, build with an older erlang.
    # We want to use `erlang@#{x-2}` where x is the major version of the `erlang` formula.
    build_erlang_version = erlang_build_dep.version.major.to_i
    wanted_erlang_version = Formula["erlang"].version.major.to_i - 2
    if wanted_erlang_version != build_erlang_version
      odie "This formula should be built with `erlang@#{wanted_erlang_version}`"
    end

    # Ensure we're building with versioned `erlang`
    ENV.remove "PATH", "#{Formula["erlang"].opt_bin}:"
    system ".bootstrap"
    bin.install "rebar3"

    bash_completion.install "appsrebarprivshell-completionbashrebar3"
    zsh_completion.install "appsrebarprivshell-completionzsh_rebar3"
    fish_completion.install "appsrebarprivshell-completionfishrebar3.fish"
  end

  test do
    deps.each do |dep|
      next unless dep.name.match?(^erlang(@\d+)?$)

      erlang = dep.to_formula
      erlang_bin = erlang.opt_bin
      erlang_version = erlang.version.major
      with_env(PATH: "#{erlang_bin}:#{ENV["PATH"]}") do
        assert_match "OTP #{erlang_version}", shell_output("#{bin}rebar3 --version")
      end
    end
  end
end