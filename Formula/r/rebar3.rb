class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://ghfast.top/https://github.com/erlang/rebar3/archive/refs/tags/3.27.1.tar.gz"
  sha256 "e34cf5e8f25fc7e59b2ff5c56fed507cf1378d4eef2a4aa7957b3c7e80812d64"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc98d9413efe323c177637a770293182f65151244634373b8dd1d77b32da3bdd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c444b4c7cf52dd62efed60a0f82b7e27eb2935d7ab4e29102b45cc0a478e2442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2a4f723453d34ed26ea453cddab72888a6aa20d46a0618f452306f68cd78ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fd3b3f35d7ac9710ed414754d219606f3b74010378467813d2656b2caee6d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ff48dad25d6b0d6498a7a9afbbf7b7edb6a8e4b87fa6578e943032af0d1a44d7"
  end

  depends_on "erlang@27" => [:build, :test]
  depends_on "erlang" => :test

  def install
    erlang_build_dep = deps.find { |dep| dep.build? && dep.name.match?(/^erlang@\d+$/) }&.to_formula
    odie "Could not find build-time erlang!" if erlang_build_dep.blank?

    # To guarantee compatibility with various erlang versions, build with an older erlang.
    # We want to use `erlang@#{x-2}` where x is the major version of the `erlang` formula.
    build_erlang_version = erlang_build_dep.version.major.to_i
    wanted_erlang_version = Formula["erlang"].version.major.to_i - 2
    if wanted_erlang_version != build_erlang_version
      odie "This formula should be built with `erlang@#{wanted_erlang_version}`"
    end

    # Ensure we're building with versioned `erlang`
    ENV.remove "PATH", "#{formula_opt_bin("erlang")}:"
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "apps/rebar/priv/shell-completion/bash/rebar3"
    zsh_completion.install "apps/rebar/priv/shell-completion/zsh/_rebar3"
    fish_completion.install "apps/rebar/priv/shell-completion/fish/rebar3.fish"
  end

  test do
    deps.each do |dep|
      next unless dep.name.match?(/^erlang(@\d+)?$/)

      erlang = dep.to_formula
      erlang_bin = erlang.opt_bin
      erlang_version = erlang.version.major
      with_env(PATH: "#{erlang_bin}:#{ENV["PATH"]}") do
        assert_match "OTP #{erlang_version}", shell_output("#{bin}/rebar3 --version")
      end
    end
  end
end