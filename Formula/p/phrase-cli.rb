class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.21.2.tar.gz"
  sha256 "afe344ddd859bd97eb984b9634e43995450c8ed2dd266312fa4ca14f8f24e68e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adfa257193c536c7908951ad00e80eb5ab1a75d1071021338cb0da717f934ff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f6c52483584f784fa543222fa3377fdde48afbdbbc3d86df460d6061414221f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7072724bda77201c338c97a404c46cacdd0d3f88f4475b66bb84b286b0c39ace"
    sha256 cellar: :any_skip_relocation, sonoma:         "f30f8599d18d15d9e060145c55b2aef9011a4cf8711fe828b565ecbdea0cac27"
    sha256 cellar: :any_skip_relocation, ventura:        "5638c475f5a0f13970d694e7c667506830acfe94da3181ffc41336a3772912ed"
    sha256 cellar: :any_skip_relocation, monterey:       "9ee0486f62f545084b27289e16c23e004b142517e113ec6cac9fceb5daa43e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ef2a217cc9ee85726ac8858f6c2c16e5999a493d09474a02363c066f824cbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end