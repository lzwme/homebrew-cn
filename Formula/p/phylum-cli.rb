class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv6.6.5.tar.gz"
  sha256 "38bc87d3a7aeabd61aedd4f6d7f9aa455f35ad4adc597237855d2ed04f541991"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49b8da27a9509213bdbd8666ec564c4b519ee50a2ca9af4b7224cc8d12400d2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4a8b85eae9f5cb2461382d0b89a8bd75eee8428d5ec6353f9daedd3d0acbe90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "726e91b69cc645169aa83d6b04f9046a751f8f0ff19c7ed6e06131d02a56dcf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "345c43b80232eaabf40ca71fb226b81b8f408781a7ebd87ae6321b2460729d99"
    sha256 cellar: :any_skip_relocation, ventura:        "97e6a6547be159546cf3ca42fbb41c13676b7dbf8782abd3aa6c2d469d0df979"
    sha256 cellar: :any_skip_relocation, monterey:       "96a884eac23b31b1f74571d5f5849d5a066b68e299d49665b94a66df4d1ac1c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b6fde8132a64fff632d0dd2f02be9045fbd2319cf4a28f59701b756382c5dd"
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