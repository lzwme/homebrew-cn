class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.20.0.tar.gz"
  sha256 "7072b888dc9df271e1f1c3042eaa01a34ae7bb782c4c54635e08c8b151e4c09c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68f3b3d66c047166560d1edf1f7243c3d4b2c3406f843d0043013cfd6f7a0d87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd56ef295c7deb17515a8d0b0715c8d0a5c2eabcc2720af2ccb3dc08cecd5de0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2ab9bbe33ea74138c0383d1fc1e759b3e8e04203622b224bc8cdc26875d60d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c431d7ad119e839bfea60279963f155bc6db9438590ba129f0094e16b9b35639"
    sha256 cellar: :any_skip_relocation, ventura:        "3f351c8458802e4bb5d5fdf8201905ad5aec6d1b74ed80ce050b2a9c1c4e0f5d"
    sha256 cellar: :any_skip_relocation, monterey:       "2303a3a1e8612f5dfe1f94a85a3938a75e58b382e69309178398467661349dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09629bea26318abca310450e84b856fd59d4fc3d4eb0148509c77713ae809a3"
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