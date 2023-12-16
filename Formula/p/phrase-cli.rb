class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghproxy.com/https://github.com/phrase/phrase-cli/archive/refs/tags/2.19.0.tar.gz"
  sha256 "e089e8e31196881adc0872c7ef25779c0b29aa41eaa24885dd12d9c87806e832"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b75ce29dd762a9c4e6cfe8443eda5628b150539237a82990795cd62c32ce99bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5440ff153c03c85c7448c59f701e2c550f6a9048dd93d07715334f681a3ed8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdd6d4a5d308d572bd29561dc9951899f83a70154b9b4c7498f7b122207c7287"
    sha256 cellar: :any_skip_relocation, sonoma:         "c41e3485617bb00ecd42ffa2da48e3d20319b6f227c516ef15fc878b34ddc99c"
    sha256 cellar: :any_skip_relocation, ventura:        "b8e45a48c20af6221da140d19ac3168132490ec7bd0d601e083cd1853767de87"
    sha256 cellar: :any_skip_relocation, monterey:       "14b88f3ae96c4aac7808ffb55d122842f3292ddc8d0abb9c3e1b9eb8f259656d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc06b39600318e33d1da9fd78f5d3951737632dce6615cde43c6b03aea28627a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end