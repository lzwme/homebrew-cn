class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.23.1.tar.gz"
  sha256 "f22ec2b0a316d2ade6498bd975c667c4faa90867a241361ef87b0e446e7d3ce2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e05606d3242d324a579221c97dab29cc3523f3f4ff1b07ecd6a71a44154baec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9684e108b387b6bb84412f900d3c6f9056066ce37de52e3480386e5398f48ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d8086e66e5f7d27545518c8ecdd313552593073b1aefe987afbd4f782ddbc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d753fd69d67e9be622aa20b337050e0216b78722151af2a42e8c5da3fceed47f"
    sha256 cellar: :any_skip_relocation, ventura:        "5f311368b7c8cffe5b31de1971539428170be910a58d1d9e123a2793beed8c59"
    sha256 cellar: :any_skip_relocation, monterey:       "bbbd721c3efbd7d908541863df6470a6c300b1836ca297798e98c4849a811884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147e8879b64b2d7972a49d4e0f272f286d7dc179211e6ad2c8b2a230a513ed95"
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