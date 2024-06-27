class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv6.6.3.tar.gz"
  sha256 "b3075dbb662bf148f392b364d2c184f929dc9c184b30b6e25322410b79309b76"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26cc2d520e6d7c158e40ca94184adc59230b59c9b9b8cbfb5f083cd92eb4dcfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe70e8a128475c3b741be4cdba3c39749a7a5a3747d167f33b686104de576113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fab32765d44d23b0f64d1f0a86afce5a5c38cfc34ca454da5ca7fad97e9eb3f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d06ffef04ea702b783a64d593248933899e96444abb9c4287b1ef7c97af356c8"
    sha256 cellar: :any_skip_relocation, ventura:        "b39551b99e2669adf04de2464f02ead63d42c263a2466ded2103be09e85cc254"
    sha256 cellar: :any_skip_relocation, monterey:       "e0334e5083900da15ba0dd1d61a0137b1f2676559848d148f4c979e81ac4761a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73f80a0e0d9ac0a04fcdad87a5caa8be519c1990281d71659c20acc66ed274d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    # Generate and install shell completions
    system "cargo", "run", "--package", "xtask", "--no-default-features", "gencomp"
    bash_completion.install "targetcompletionsphylum.bash" => "phylum"
    zsh_completion.install "targetcompletions_phylum"
    fish_completion.install "targetcompletionsphylum.fish"
  end

  def caveats
    <<~EOS
      No official extensions have been preinstalled.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}phylum --version")

    output = shell_output("#{bin}phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end