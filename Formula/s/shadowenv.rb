class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https:shopify.github.ioshadowenv"
  url "https:github.comShopifyshadowenvarchiverefstags3.0.2.tar.gz"
  sha256 "263889408e47008803e4e91a309050df82963349d81e8777a3d1a1a924d29c6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e93a45b2872541cde83f6c9767293d5b84630a1cbf631f1b73e067afd689890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef3dee141fac1bf7c108a5bf44bad36daa5187815f3703a16305d48419a2f077"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "826f0909baaffef8f7468ab1b06f70c4adafac3020c19ae22661ed1e545cc85b"
    sha256 cellar: :any_skip_relocation, sonoma:        "57fc8d8ab168c72711f5aea11c5087c36505a2f7d1b4bf82142e3755e4144899"
    sha256 cellar: :any_skip_relocation, ventura:       "cb06cc05fa5c8d0650f6e6dbfd6062b5eaa0645a4882369fdb7d041580e0db91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46be71c90fcf022dfcbe045fd27d471edcc6cdcaab7690b7f22d73b08dc595bf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "#{buildpath}manman1shadowenv.1"
    man5.install "#{buildpath}manman5shadowlisp.5"
  end

  test do
    expected_output = <<~EOM
      EXAMPLE:
      EXAMPLE2:b
      EXAMPLE3:b
      EXAMPLE_PATH:a:b:d
      ---
      EXAMPLE:
      EXAMPLE2:b
      EXAMPLE3:b
      EXAMPLE_PATH:a:b:d
    EOM
    environment = "export EXAMPLE2=b EXAMPLE3=b EXAMPLE_PATH=a:b:d;"
    hash = "1256a7c3de15e864"
    data = {
      "scalars" => [
        { "name" => "EXAMPLE2", "original" => nil, "current" => "b" },
        { "name" => "EXAMPLE", "original" => "a", "current" => nil },
        { "name" => "EXAMPLE3", "original" => "a", "current" => "b" },
      ],
      "lists"   => [
        { "name" => "EXAMPLE_PATH", "additions" => ["b", "a"], "deletions" => ["c"] },
      ],
    }
    # Read ...'\"'\"'... on the next line as a ruby `...' + "'" + '...` but for bash
    shadowenv_command = "#{bin}shadowenv hook '\"'\"'#{hash}:#{data.to_json}'\"'\"' 2> devnull"
    print_vars =
      "echo EXAMPLE:$EXAMPLE; echo EXAMPLE2:$EXAMPLE2; echo EXAMPLE3:$EXAMPLE3; echo EXAMPLE_PATH:$EXAMPLE_PATH;"

    assert_equal expected_output,
      shell_output("bash -c '#{environment} #{print_vars} echo ---; eval \"$(#{shadowenv_command})\"; #{print_vars}'")
  end
end