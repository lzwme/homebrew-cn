class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv6.4.0.tar.gz"
  sha256 "71dcddb28a3073123aad14ee200535c8ba3bbedd48d3441f30e2181cadb52d18"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa76ec8cdff3e898b5acd87b3915d7017e9cb9948c87b64af51e9771bbbe6d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d58e07741c3de9de33ab0827817f540b93df0d53ff9793d16e3f33506a15c02a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "416da734e7cb54236a50388340725c1f92a26a8aa7473f10e3581d4954e5cf84"
    sha256 cellar: :any_skip_relocation, sonoma:         "52de675cdbbed8d32b764b0d7b87ba2f9031b4d3957bf1a441ecc655c08fa8e1"
    sha256 cellar: :any_skip_relocation, ventura:        "78b1420179409bc721b0198bd199a0b9aa85b1598d4a0eb0fedb9e4eed245397"
    sha256 cellar: :any_skip_relocation, monterey:       "a02f07af6ee4eb0227cfd405dd2495052d2b953a93b2e603941de09229312808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cab24bec8d03000f58b853d6cab311de78d6fed14a6a7bd79bb3c377fc574a32"
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