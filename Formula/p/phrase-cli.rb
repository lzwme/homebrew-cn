class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.31.0.tar.gz"
  sha256 "5b35a69c2101559b709a3a79eb4dba2c54724876ec57700d33bcc77ad7e2d4b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07f2f6b59c68de56d543b76abc8b772da04a3e0a0d8fdc17eb4b4cd10eaa6580"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "429661aae1e2e0969f5e09f6720b5ea49f32118f387d22e04d215edbb6137180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50932ba792bedecbd1d5102aa5a24925f2e5dc521571d79cf35655bd16d83b58"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cb38e38eca45e0aeb27ad5e0cc3ea5059282c85a173c46d1fe9105682a371a7"
    sha256 cellar: :any_skip_relocation, ventura:        "05ef88ec7f704d663a7603c4dc9ecc3e2e72a401e4a16c94dded35f3df107120"
    sha256 cellar: :any_skip_relocation, monterey:       "6f3539af555a17358ab0262ceb5630163394e3688aae6498e0c0a67b13ec5212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0df2d00647a0e4aaf4252212e56b4bc352430dc190a75b2778c083e2b6226f7c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end