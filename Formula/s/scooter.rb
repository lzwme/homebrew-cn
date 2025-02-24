class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https:github.comthomasschaferscooter"
  url "https:github.comthomasschaferscooterarchiverefstagsv0.3.0.tar.gz"
  sha256 "bdaaf67e8fecb4ea53dcd74c576261ceb8640e6fdbf8fb86d350eb38206313fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea777b69bdb0e1e4d6d96a2b4d87abecfd615f1b4c3acaeae62e65c826bc60e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec934e46bc13f025c2746b1b3395e39c89597fced96abc7317b55dbe0f052d1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "962e3dc372a19601991fa70e6ce2da34442f61b2cf3883a42e39f77efacd0810"
    sha256 cellar: :any_skip_relocation, sonoma:        "10aa672592f7d05c2073467ce7f66ffb20f65a9d1670b4506d2f8f18cb38ea12"
    sha256 cellar: :any_skip_relocation, ventura:       "0b15fc285930839815b7af0ec8b83091c2892c3d126af0fe602f9aee7bdf9057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b66c8eb03a388c69e4d2a90bf5e8cf6c755a3998038ec697c60433efae1920"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}scooter -h")
  end
end