class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://ghfast.top/https://github.com/samwho/spacer/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "543ad6081bb61cfd69aa5feb88efb4c10b217a4755c871f688e44693ff3b5b1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09bd46f1471e47a7eb2e77d851f1c36bfedaf0f10520e5370cc692eb3f4ed3b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a515fed985dfe49d00ced90240b69aebdfb448edd51791dfa750d60f46da2b52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9929d57f6caccee5b650e3ad3c6919494b738fa660bc7ddc4b18a68df1bc056"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fa3f8c7b42565e4ccf3503185b5115705ef6c71d17cb88aee1c7052b053c026"
    sha256 cellar: :any_skip_relocation, ventura:       "6cfc26091a933546bafabca7bf7f7842605eadf56722c96285532fe57a8329b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4950b650094d937bc91f6abfdbbf4729f146c7dce84bdc6615b909f31079d303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b6742b28126fdfafbc82342dd824ee60e2140894a3464d8d0af50732d62363"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spacer --version").chomp
    date = shell_output("date +'%Y-%m-%d'").chomp
    spacer_in = shell_output(
      "i=0
      while [ $i -le 2 ];
        do echo $i; sleep 1
        i=$(( i + 1 ))
      done | #{bin}/spacer --after 0.5",
    ).chomp
    assert_includes spacer_in, date
  end
end