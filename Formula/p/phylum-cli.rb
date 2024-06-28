class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv6.6.4.tar.gz"
  sha256 "92943eaed3207e2dc4f1cd3b9216319d747c12a36bec9ace8aa84ddb8218cb92"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d8731f22098f84d31bbc21a9eb2b828c9989e5a1aea3c6f5fc8591e1d5ebf5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7799f2f169f5c61e3b989229d8e47397694e5e865bf4e802b7f7ee626d3c4cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bca2104005359b91abf8e6fba66a29ab1d7df628e98952d2439c100a808bad4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cf53b2d28b73381f3eaa1b87c38b24ad946d57a6f40fbcfcc051ac881b752f0"
    sha256 cellar: :any_skip_relocation, ventura:        "8f5679d54920034397f2718f6a1cb539f3e1157f3e4debf8cbcb3fc27a2acd82"
    sha256 cellar: :any_skip_relocation, monterey:       "09420d1b78b5437d6795ad0de496fba718711e54fc59be294b36b92137fa7f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814ff8430e5007ede1f4634411f021906691f4e0861687072466363adecb9ba7"
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