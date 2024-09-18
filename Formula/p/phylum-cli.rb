class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv7.0.0.tar.gz"
  sha256 "42565684950ac90c6197eaffe406d6e890811204c76122d536678e7dee2be83e"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f59e4ddd2fa4c65f03e34bb88675bc0e00e1d0fca7ac5009b93ea8c01245de45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "421ab48f73091ea53b1fa0d1c2466b11e5f740e1c324e09a2d46bd363e4959f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53ee2906b2083c34b55af61485ca89726ab36b86b4060df056cbc34a929b79d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb795d6eb2b37a16863134a9d11b77c6ae013530c699e34abd9c29c37d4967f0"
    sha256 cellar: :any_skip_relocation, ventura:       "88a871c912ddc008f11676ba071af5805622469b8abbe0a01a7bbe044ed88e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c0026b398be339e8a78a5975bcb70488bee32059119a1548880ac9820bce38"
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