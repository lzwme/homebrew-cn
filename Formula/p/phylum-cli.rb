class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv7.4.0.tar.gz"
  sha256 "99c5c0855fd302767d61546df15f75ad5572664d82955fcd9eb61aeb0acef720"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cc2bb7882a0560c69aa8c814411576e50142bd00dfb122c64b2fd7aeebb92ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c024335395e20ccb96fd9b8686d92f264fe20902ea5db42b5dfc79762a52891"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "269b4c5f0bdb27eca5877aeca63917c6f4fc89db1b6c37eb2b3662d6b0958413"
    sha256 cellar: :any_skip_relocation, sonoma:        "266555f6e8906d4a6f73fe3c0e9e9afd2603c237488e25604fb8144481fec0ce"
    sha256 cellar: :any_skip_relocation, ventura:       "c924ab7775ac2d61f06727c098a87d2735ddab21f2168117a77d1b06cff892d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7cb586a588376613c693efd48b35a795aecbea235f2f781271b0129aacf6298"
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

    assert_match <<~EOS, shell_output("#{bin}phylum status")
      Project: null
      Group: null
      Project Root: null
      Dependency Files: null
    EOS
  end
end