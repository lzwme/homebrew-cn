class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv6.6.1.tar.gz"
  sha256 "00f61cbc853c66d7a59145272b15f29a19e2bccc6af11fb885ec3925011c34b6"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3490b161aa165ada03cadcf8a79135ba7cf767308a79f0a72aa45252ecd139cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96b5808b867025699120abfd9c14f10596d822b635256f102139d7b555ea8b6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b99d40dde46571a973f46079103be5d835f04f77477840ecd4deec866f8f1133"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1c4ce2d9503d2e20ac881246241cb50e0538f7962cd954513ea1f5e9fc284b0"
    sha256 cellar: :any_skip_relocation, ventura:        "aa858e834a9a48ac9ce3790bded4fa2f612f6558f85895f9f6b70207ca02975a"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2c44518b70baef66ac93d55dabd43ac9e9854891ab98b8be57686420943fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0fce391f75a95fe5ff63d11bc6f2ff7ffc30f03c72c13d022931f30b5601bd1"
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